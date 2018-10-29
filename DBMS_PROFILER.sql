CREATE OR REPLACE TRIGGER SYS.TRG_enable_10046_trace
AFTER logon on SYSPERGAMUM.SCHEMA
DECLARE
--    10046 TRACELEVELS
--    0  - Turn off tracing.
--    1  - Basic SQL_TRACE.
--    4  - Level 1 plus Bind Variables.
--    8  - Level 1 plus wait events.
--    12 - Level 1 plus Bind Variables and Wait event information.
   l_result      NUMBER;
   v_ipaddress   VARCHAR2(100);
BEGIN
   SELECT SYS_CONTEXT('USERENV','ip_address') INTO v_ipaddress FROM dual;
   IF v_ipaddress = '10.1.241.201' THEN
      l_result:=DBMS_PROFILER.START_PROFILER ('SYSPERGAMUM : '||to_char(sysdate,'dd-Mon-YYYY hh:mi:ss'));
      EXECUTE IMMEDIATE 'alter session set timed_statistics = true';
      EXECUTE IMMEDIATE 'alter session set max_dump_file_size = unlimited';
      EXECUTE IMMEDIATE 'alter session set tracefile_identifier = ''session_trace_SYSPERGAMUM''';
      EXECUTE IMMEDIATE 'alter session set events ''10046 trace name context forever, level 4'''; 
   END IF;
END;

delete from plsql_profiler_data;
delete from plsql_profiler_units;
delete from plsql_profiler_runs;

SELECT u.runid,
       u.unit_number,
       u.unit_timestamp,
       u.unit_type,
       u.unit_owner,
       u.unit_name,
       d.line#,
       d.total_occur,
       d.total_time,
       d.min_time,
       d.max_time
FROM   plsql_profiler_units u
       JOIN plsql_profiler_data d ON u.runid = d.runid AND u.unit_number = d.unit_number
WHERE u.unit_name <> '<anonymous>' and to_char(u.unit_timestamp,'dd/mm/yyyy') = '14/08/2013'
ORDER BY u.runid,u.unit_timestamp, d.line#;

select
     b.run_owner,
     b.run_date,
     decode(a.unit_name, '', '<anonymous>',
     substr(a.unit_name,1, 40)) as object_name
     from plsql_profiler_units a, plsql_profiler_runs b
     where a.runid=b.runid and to_char(run_date,'dd/mm/yyyy') = '14/10/2014' and a.unit_name <> '<anonymous>'
     order by b.run_date;
     
     