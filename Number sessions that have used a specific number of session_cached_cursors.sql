The following sql will show the number sessions that have used a specific number of session_cached_cursors – aim for a value that catches
the majority of sessions, but bear in mind that there will nearly always be some sessions that run up to the limit.



select s.value used, count(1) from  v$statname  n, v$sesstat  s
       
where n.name = 'session cursor cache count'
and   s.statistic# = n.statistic#
group by s.value
order by s.value