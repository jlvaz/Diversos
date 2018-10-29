 SELECT  C.SQL_TEXT,
        B.NAME,
        COUNT(*),
        SUM(TIME_WAITED)
FROM    v$ACTIVE_SESSION_HISTORY A,
        v$EVENT_NAME B,
        v$SQLAREA C
WHERE   A.SAMPLE_TIME BETWEEN to_date('03/09/14 10:00','dd/mm/yy hh24:mi') AND
                              to_date('03/09/14 10:40','dd/mm/yy hh24:mi') AND
        A.EVENT# = B.EVENT# AND
       -- A.SESSION_ID= 123 AND
        A.SQL_ID = C.SQL_ID
GROUP BY C.SQL_TEXT, B.NAME