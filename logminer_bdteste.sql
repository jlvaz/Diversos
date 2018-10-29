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
   logfilename => '+DATA3/bdteste/onlinelog/group_3.263.962089711');

END;

update psecao set codcoligada = 1 where 1 = 2

exec DBMS_LOGMNR.START_LOGMNR(options => dbms_logmnr.dict_from_online_catalog);


create table t_logmnr_contents_UNIFESO as SELECT timestamp, scn, operation, sql_redo, sql_undo FROM v$logmnr_contents WHERE 1=2;

alter table t_logmnr_contents_UNIFESO NOLOGGING

 
   
begin                          
        dbms_logmnr.end_logmnr;
end;         
   
		 
		 
