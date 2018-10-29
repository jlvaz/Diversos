NO SYSPERGAMUM :

BEGIN
   SYS.DBMS_SCHEDULER.DROP_JOB (job_name => 'J_PERGA_AUTOMATICO');
END;

BEGIN
  DBMS_SCHEDULER.create_job (
    JOB_NAME        => 'J_PERGA_AUTOMATICO',
    JOB_TYPE        => 'PLSQL_BLOCK',
    JOB_ACTION      => 'BEGIN  sp_per_automatico_dia_P11(349,sysdate); END;',
    START_DATE      => SYSTIMESTAMP,
    REPEAT_INTERVAL => 'freq=minutely; BYDAY=MON,TUE,WED,THU,FRI; byminute=15',
    END_DATE        => NULL,
    ENABLED         => TRUE,
    COMMENTS        => 'Job defined entirely by the CREATE JOB procedure.');
END;

NO UNIVERSUS :

BEGIN
   SYS.DBMS_SCHEDULER.DROP_JOB (job_name => 'J_UNIVERSUS_AUTOMATICO');
END;

BEGIN
  DBMS_SCHEDULER.create_job (
    JOB_NAME        => 'J_UNIVERSUS_AUTOMATICO',
    JOB_TYPE        => 'PLSQL_BLOCK',
    JOB_ACTION      => 'BEGIN  EXP_MULTA; END;',
    START_DATE      => SYSTIMESTAMP,
    REPEAT_INTERVAL => 'freq=minutely; BYDAY=MON,TUE,WED,THU,FRI; interval=20',
    END_DATE        => NULL,
    ENABLED         => TRUE,
    COMMENTS        => 'Job defined entirely by the CREATE JOB procedure.');
END;


