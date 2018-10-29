 Moving controlfile from filesystem to ASM disk using RMAN in RAC.

You can migrate controlfile from file system to asm disk or to different diskgroup in ASM. For that you have to stop the database and startup in nomount state.


STEP 1: Stop the Database and startup in nomount state

SQL> shutdown immediate;
SQL> startup nomount;



STEP 2:Connect the target database using RMAN

$ rman
RMAN>connect target /
RMAN>restore controlfile to '<DISKGROUP_NAME>' from '<OLD_PATH>';

RMAN> restore controlfile to '+SYSTEM_DATA' from '+FRA/dmoodle/controlfile/current.262.922998299';


You can also multiplex controlfile to FRA like:

RMAN> restore controlfile to '+FRA' from '+FRA/dmoodle/controlfile/current.262.922998299';



STEP 3: Show Location Of New Control Files

ASMCMD> find -t controlfile . *
+DATA/DG/CONTROLFILE/current.321.780791421
+FRA/DG/CONTROLFILE/current.368.870851527



STEP 4: On the database side:
 Modify init.ora or spfile, replacing the new path to the init parameter control_files.
 if using init<SID>.ora, just modify the control_files parameter and restart the database.
 If using spfile, Change Parameter for new locations.

alter system set control_files='+SYSTEM_DATA/DMOODLE/CONTROLFILE/current.263.976894987','+FRA/dmoodle/controlfile/current.262.922998299' scope=spfile;

startup force