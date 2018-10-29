BEGIN
   dbms_stats.flush_database_monitoring_info;
END;

select * from ALL_TAB_MODIFICATIONS WHERE TABLE_OWNER = 'RM' AND table_name = 'PFFINANC'

Criação do dicionário

BEGIN
   DBMS_LOGMNR_D.build (
   dictionary_filename => 'dictdbfeso2.ora',  dictionary_location => '/u03/dict');
END;


select * from v$log  status CURRENT

BEGIN
   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.new,
   logfilename => '/u01/app/oracle/oradata/bdrmnet/redo01.log');

   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.addfile,
   logfilename => '/u01/app/oracle/oradata/bdrmnet/redo02.log');

   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.addfile,
   logfilename => '/u01/app/oracle/oradata/bdrmnet/redo03.log');

   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.addfile,
   logfilename => '/u01/app/oracle/oradata/bdrmnet/redo04.log');
END;

update psecao set codcoligada = 1 where 1 = 2

exec DBMS_LOGMNR.START_LOGMNR(options => dbms_logmnr.dict_from_online_catalog);


create table t_logmnr_contents_UNIFESO as SELECT timestamp, scn, operation, sql_redo, sql_undo FROM v$logmnr_contents WHERE 1=2;

alter table t_logmnr_contents_UNIFESO NOLOGGING

CREATE OR REPLACE PROCEDURE PROC_LOGMINER_UNIFESO (p_data_inicio   timestamp, p_data_final    timestamp)
AS
   plsql_block    VARCHAR2(500);
   v_member       VARCHAR2(500);
BEGIN
      
   SELECT l1.member  INTO v_member FROM v$logfile l1, v$log l2
          WHERE l1.group# = l2.group# AND l2.status = 'CURRENT'; 
   plsql_block:='BEGIN DBMS_LOGMNR.add_logfile ( options => DBMS_LOGMNR.new,
                       logfilename => :1); END;';
   EXECUTE IMMEDIATE plsql_block USING v_member;
   DBMS_LOGMNR.start_logmnr ( dictfilename => '/u03/dict/dictdbfeso2.ora');
   
   FOR I IN (SELECT timestamp, scn, operation, sql_redo, sql_undo FROM v$logmnr_contents 
                    WHERE sql_redo NOT LIKE ('%SYS%') AND timestamp BETWEEN p_data_inicio AND p_data_final) LOOP
       DBMS_OUTPUT.put_line(to_char(I.timestamp, 'dd/mm/yy hh24:mi:ss') || '  ' ||  I.operation || '  ' || I.sql_redo);
   END LOOP;
   COMMIT;
   
   DBMS_LOGMNR.end_logmnr;
END;
   
   
          
   
		 
		 
		 

rebuild schema indexes 

analyze index <index_name> validate structure;

An index should be considered for rebuilding under any of the following conditions:

* The percentage of deleted rows exceeds 30% of the total, i.e. if
del_lf_rows / lf_rows > 0.3.
* If the ‘HEIGHT’ is greater than 4.
* If the number of rows in the index (‘LF_ROWS’) is significantly smaller than ‘LF_BLKS’ this can indicate a large number of deletes, indicating that the index should be rebuilt.
refer the link:

Then query INDEX_STATS view
1. If del_lf_rows/lf_rows is > .2 then index should be rebuild.
2. If height is 4 then index should be rebuild.
3. If lf_rows is lower than lf_blks then index should be rebuild.

column status format a10
select trunc((del_lf_rows/lf_rows)*100,2)||'%' "status" from index_stats;

begin
   dbms_stats.gather_table_stats('rm','pffinanc');
end;
