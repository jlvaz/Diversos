CREATE OR REPLACE TRIGGER SYS.TRG_enable_10046_trace
AFTER logon on database
DECLARE
--    10046 TRACELEVELS
--    0  - Turn off tracing.
--    1  - Basic SQL_TRACE.
--    4  - Level 1 plus Bind Variables.
--    8  - Level 1 plus wait events.
--    12 - Level 1 plus Bind Variables and Wait event information.
BEGIN
   IF user IN ('RM') THEN
      EXECUTE IMMEDIATE 'alter session set timed_statistics = true';
      EXECUTE IMMEDIATE 'alter session set max_dump_file_size = unlimited';
      EXECUTE IMMEDIATE 'alter session set tracefile_identifier = ''session_trace_RM''';
      EXECUTE IMMEDIATE 'alter session set events ''10046 trace name context forever, level 12'''; 
   END IF;
END;
/

create or replace trigger TRG_enable_10046_trace_endsqltracing before logoff on RM.schema
begin
    execute immediate 'alter session set events ''10046 trace name context off''';
end;



Enable tracing
------------------------------------
EXEC DBMS_MONITOR.session_trace_enable(session_id =>42, serial_num=>293, waits=>TRUE, binds=>TRUE);

Disable Tracing
-------------------------------
EXEC DBMS_MONITOR.session_trace_disable(session_id=>42, serial_num=>293);

http://www.fabioprado.net/2013/09/analisando-traces-em-bancos-de-dados.html?showComment=1537544488848#c2458066278276421907

Identify trace file using  SID
==========================================

SELECT p.tracefile
FROM   v$session s
       JOIN v$process p ON s.paddr = p.addr
WHERE  s.sid = 42;


Example
----------------

SQL> SELECT p.tracefile
FROM   v$session s
       JOIN v$process p ON s.paddr = p.addr
WHERE  s.sid = 42;  

TRACEFILE
--------------------------------------------------------------------------------
/u01/app/oracle/diag/rdbms/hr/hr/trace/hr_ora_10369.trc




Identifying Trace Files

Oracle allows you to set the TRACEFILE_IDENTIFIER parameter at session level, allowing you to include some recognizable text into the trace file name.

ALTER SESSION SET TRACEFILE_IDENTIFIER = "MY_TEST_SESSION";

Even without this, we can easily identify the trace file for the current session using the USER_DUMP_DEST value with the instance name and the session's process id. The identify_trace_file.sql script combines these values to produce the expected trace file name.

SET LINESIZE 100
COLUMN trace_file FORMAT A60

SELECT s.sid,
       s.serial#,
       pa.value || '/' || LOWER(SYS_CONTEXT('userenv','instance_name')) ||    
       '_ora_' || p.spid || '.trc' AS trace_file
FROM   v$session s,
       v$process p,
       v$parameter pa
WHERE  pa.name = 'user_dump_dest'
AND    s.paddr = p.addr
AND    s.audsid = SYS_CONTEXT('USERENV', 'SESSIONID');
