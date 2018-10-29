1) Identify the data file to be moved.
2) Identify the diskgroup on to which the file has to be moved.
3) Take the file offline.
4) Copy the file to new diskgroup using Either RMAN or DBMS_FILE_TRANSFER.
5) Rename the file to point to new location.
6) Recover the file.
7) Bring the file online.
8) Verify the new file locations.
9) Delete the file from its original location.


startup mount

alter database archivelog;

alter database open;


archive log list;  /u01/app/oracle/product/11.2.0/dbhome_1/dbs/arch

alter database open;

1) SELECT FILE_NAME FROM DBA_DATA_FILES:     +DATA/dbfeso1/datafile/rm_dados.289.923005267   dbfeso1    +DISK_5

2) sqlplus> SELECT GROUP_NUMBER, NAME FROM V$ASM_DISKGROUP;   +DATA

3) sqlplus> ALTER DATABASE DATAFILE '+DATA/dbfeso1/datafile/rm_dados.289.923005267' OFFLINE;   ALTER DATABASE DATAFILE <data_file_name> OFFLINE;

4) rman target /  

   COPY DATAFILE '+DATA/dbfeso1/datafile/rm_dados.289.923005267' TO '+DISK_5';   COPY DATAFILE <data_file_name_origem> TO <data_file_name_destino>;

   Starting backup at 03-AUG-05
                   using target database controlfile instead of recovery catalog
                   allocated channel: ORA_DISK_1
                   channel ORA_DISK_1: sid=146 devtype=DISK
                   channel ORA_DISK_1: starting datafile copy
                   input datafile fno=00004 name=+DATA/dbfeso1/datafile/rm_dados.289.923005267
                   output filename===+DATA3/dbfeso2/datafile/rm_dados.304.977754889 tag=TAG20180510T143741 RECID=2 STAMP=975768050
                   channel ORA_DISK_1: datafile copy complete, elapsed time: 00:03:15
                   Finished backup at 10-MAY-18

5) O comando set newname define a nova localização do datafile a ser restaurado.
   RMAN> run {
             2> set newname for datafile '+DATA/dbfeso1/datafile/rm_dados.289.923005267' to '+DATA3/dbfeso2/datafile/rm_dados.304.977754889';     set newname for datafile <data_file_name_origem>  to <data_file_name_destino> ;
             3> switch datafile all;
             4> }

   executing command: SET NEWNAME

   datafile 6 switched to datafile copy
   input datafile copy RECID=2 STAMP=975768050 file name=+DATA1/dmoodle/datafile/dmoodle.297.975771461

			
6) Efetuar o RECOVER -           RMAN> RECOVER DATAFILE '+DATA3/dbfeso2/datafile/rm_dados.304.977754889';    RECOVER DATAFILE <data_file_name_destino>;

                                       Starting recover at 10-MAY-18
                                       using channel ORA_DISK_1

                                       starting media recovery
                                       media recovery complete, elapsed time: 00:00:00

                                       Finished recover at 10-MAY-18

							 

7) Colocar o datafile ONLINE  - sqlplus>  ALTER DATABASE DATAFILE '+DATA3/dbfeso2/datafile/rm_dados.304.977754889' ONLINE;    ALTER DATABASE DATAFILE <data_file_name_destino> ONLINE
                                          Database altered.
							 
							 
8) Elimina o Datafile antigo  - RMAN> DELETE DATAFILECOPY '+DATA/dbfeso1/datafile/rm_dados.289.923005267';   DELETE DATAFILECOPY <data_file_name_origem>




SYSTEM/ SYSAUX   /u01/app/oracle/product/11.2.0/dbhome_1/dbs/arch

startup mount

alter database archivelog;

alter database open;

We need to move database files to NEW diskgroup
 I need to switch the datafiles to this copy. 
 However,  SYSAUX is considered a “system” tablespace so this can only be done with the database mounted but not open, 
 so I first need to shutdown the database then do a startup mount command:

    SQL> shutdown immediate;
    SQL> startup mount;
	
	 1) rman target /  REPORT SCHEMA;
	
   Backup AS COPY "database files" to NEW diskgroup, then SWITCH DATAFILE to use NEW diskgroup

     2) RMAN> BACKUP AS COPY DATAFILE 1 FORMAT "+SYSTEM_DATA";
              BACKUP AS COPY DATAFILE 2 FORMAT "+SYSTEM_DATA";
              SWITCH tablespace system TO COPY;
              SWITCH tablespace sysaux TO COPY;

		
     3) Recover the changes made to these tablespaces;
        RMAN> recover database;
		
   Open database...

     4) SQL> alter database open;
	 
   After make sure...(no error and database files used in NEW diskgroup), then DELETE old datafilecopy(original)...

    RMAN> DELETE DATAFILECOPY '+DATA/dbfeso1/datafile/ts_bdi_dat.294.923029825';
          DELETE DATAFILECOPY '+DATA/dmoodle/datafile/sysaux.279.922998231';
   

		
    If not "SYSTEM" database file. we can move database file while database open...
