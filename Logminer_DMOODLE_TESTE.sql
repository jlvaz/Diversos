Execução da criação do dicionário para o logminer
BEGIN
   DBMS_LOGMNR_D.build (
   dictionary_filename => 'dictdmoodle.ora',  dictionary_location => '/u03/dict');   
END;

Identificando arquivos de log

Substitua a consulta abaixo com os horários de inicio e término do período onde você acredita que ocorreram os comandos que você esta buscando, neste exemplo vamos utilizar os horários das consultas listadas acima.

select NAME, to_char(FIRST_TIME,'dd-mm-yyyy hh24:mi:ss') FIRST_TIME
 from V$ARCHIVED_LOG
 where first_time > to_date('15-06-2010 14:13:39','dd-mm-yyyy hh24:mi:ss')
   and first_time < to_date('15-06-2010 14:15:56','dd-mm-yyyy hh24:mi:ss');

select * from v$logfile   IS_Recovery_dest_file

Este é o 1o.passo para execução da leitura dos REDOs
BEGIN
   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.new,
   logfilename => '+DATA/dmoodle/onlinelog/group_1.296.894988341');

   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.addfile,
   logfilename => '+DATA/dmoodle/onlinelog/group_2.297.894988341');

   DBMS_LOGMNR.add_logfile (
   options => DBMS_LOGMNR.addfile,
   logfilename => '+DATA/dmoodle/onlinelog/group_3.298.894988341');

END;

-- ANALYZE using TIME
-- ==================
begin
      dbms_logmnr.start_logmnr( DICTFILENAME=> '/u01/dict/dictdbfeso1.ora',
                                   STARTTIME=> to_date('08-Mai-2014 13:00:00', 'DD-MON-YYYY HH24:MI:SS'),
                                   ENDTIME=>   to_date('08-Mai-2014 16:00:00', 'DD-MON-YYYY HH24:MI:SS'));
end;

-- ANALYZE using SCN
-- =================
 begin
      dbms_logmnr.start_logmnr( dictfilename=> '/oracle/dictionary.ora',
                                STARTSCN=> 100,
                                ENDSCN=> 150);
 end;
/

execute dbms_logmnr.start_logmnr()

Iniciando o Logminer

BEGIN
 DBMS_LOGMNR.START_LOGMNR(
 options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.COMMITTED_DATA_ONLY); 
END;

EXECUTE DBMS_LOGMNR.START_LOGMNR(options => dbms_logmnr.dict_from_online_catalog);

EXECUTE DBMS_LOGMNR.START_LOGMNR(OPTIONS => DBMS_LOGMNR.COMMITTED_DATA_ONLY);


create table t_logmnr_contents_UNIFESO as SELECT timestamp, scn, operation, sql_redo, sql_undo FROM v$logmnr_contents where seg_owner = 'SIMPRESS'

EXEC DBMS_LOGMNR.end_logmnr


select ORA_ROWSCN, scn_to_timestamp (ORA_ROWSCN) from dept where deptno = 99

SCN_TO_TIMESTAMP will only be able to convert the SCN to a timestamp if the revision occurred within the last five days. Otherwise you get the lovely error: “ORA-08181: specified number is not a valid system change number”.


BEGIN
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME => '/u02/archives/01_1622_PRD.arc', OPTIONS => DBMS_LOGMNR.NEW);
DBMS_LOGMNR.START_LOGMNR(OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.COMMITTED_DATA_ONLY);
END;
/

