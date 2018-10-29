SELECT * 
       FROM (SELECT ROUND ( ( (cpu_time / 1000000) / 60), 2) AS "Tempo total de CPU",
       s.inst_id,
       s.sid,
       s.sql_ID,
       s.module,
       s.client_info,
       p.pid,
       s.serial#,
       p.spid,
       s.username,
       a.sql_text
FROM   gv$session s, gv$process p, v$sqlarea a
       WHERE p.addr = s.paddr AND p.inst_id = s.inst_id and s.sql_id = a.sql_id
ORDER BY ROUND ( ( (cpu_time / 1000000) / 60), 2) desc)
