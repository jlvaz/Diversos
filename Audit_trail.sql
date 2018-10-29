SQL> alter system set audit_sys_operations=TRUE scope=SPFILE;

System altered.

SQL> alter system set audit_trail=db_extended scope=SPFILE;

System altered.

TRUNCATE TABLE SYS.AUD$

AUDIT INSERT , UPDATE , DELETE
    ON moodle.m_user
    BY ACCESS;
    

AUDIT INSERT , UPDATE , DELETE
    ON moodle.m_course
    BY ACCESS;
    
AUDIT INSERT , UPDATE , DELETE
    ON moodle.M_USER_ENROLMENTS by access

AUDIT INSERT , UPDATE , DELETE
    ON moodle.M_CONTEXT by access

AUDIT INSERT , UPDATE , DELETE
    ON moodle.M_ROLE_ASSIGNMENTS by access

AUDIT INSERT , UPDATE , DELETE
    ON moodle.M_ENROL by access


SELECT username,obj_name,action_name, sql_text
    FROM   dba_audit_trail
    WHERE  username = 'MOODLE' and action_name not in ('LOGON','LOGOFF')
    ORDER BY timestamp;


