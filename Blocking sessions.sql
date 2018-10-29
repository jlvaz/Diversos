SELECT                                                           /*+ RULE */
        LPAD ('--->', DECODE (A.REQUEST, 0, 0, 5)) || A.SID SID,
         B.SERIAL#,
         DECODE (TRUNC (SYSDATE - LOGON_TIME),
                 0, NULL,
                 TRUNC (SYSDATE - LOGON_TIME) || ' Days' || ' + ')
         || TO_CHAR (
               TO_DATE (TRUNC (MOD (SYSDATE - LOGON_TIME, 1) * 86400), 'SSSSS'),
               'HH24:MI:SS')
            LOGON,
         B.STATUS,
         B.SCHEMANAME SCHEMA,
         DECODE (O.OWNER || '.' || O.OBJECT_NAME,
                 '.', NULL,
                 O.OWNER || '.' || O.OBJECT_NAME)
            OBJECT,
         O.OBJECT_TYPE,
         B.OSUSER,
         B.MACHINE,
         B.MODULE,
         B.PROGRAM,
         DECODE (BLOCK, 0, NULL, 'BLOCKER')
         || DECODE (REQUEST, 0, NULL, '-->WAITER')
            BLOCKER,
         DECODE (A.LMODE,
                 0, 'None',
                 1, 'Null',
                 2, 'Row-S (SS)',
                 3, 'Row-X (SX)',
                 4, 'Share',
                 5, 'S/Row-X (SSX)',
                 6, 'Exclusive',
                 A.LMODE)
            LMODE,
         DECODE (
            TRUNC (CTIME / 86400),
            0, TO_CHAR (TO_DATE (CTIME, 'SSSSS'), 'HH24:MI:SS'),
            TRUNC (CTIME / 86400) || ' Days + '
            || TO_CHAR (
                  TO_DATE (CTIME - (TRUNC (CTIME / 86400)) * 86400, 'SSSSS'),
                  'HH24:MI:SS'))
            TIME,
         A.TYPE,
            'alter system kill session '
         || ''''
         || A.SID
         || ', '
         || B.SERIAL#
         || ''''
         || ' immediate;'
            KILL_SESSION,
         DECODE (
            OBJECT_TYPE,
            NULL, NULL,
               'Dbms_Rowid.rowid_create(1, '
            || ROW_WAIT_OBJ#
            || ', '
            || ROW_WAIT_FILE#
            || ',
'
            || ROW_WAIT_BLOCK#
            || ', '
            || ROW_WAIT_ROW#
            || ')')
            ROW_ID
    FROM V$LOCK A, V$SESSION B, DBA_OBJECTS O
   WHERE A.SID = B.SID AND (LMODE = 0 OR BLOCK = 1)
         AND O.OBJECT_ID(+) =
                DECODE (B.ROW_WAIT_OBJ#, -1, NULL, B.ROW_WAIT_OBJ#)
ORDER BY A.ID1, A.REQUEST;