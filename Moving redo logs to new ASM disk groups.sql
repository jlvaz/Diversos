Moving redo logs to new ASM disk groups

alter system set db_create_online_log_dest_1='+ASM_ORADATA43';
alter system set db_create_online_log_dest_2='+ASM_ORADATA43';

select group#, status from v$log;

ALTER DATABASE DROP LOGFILE GROUP 1;
ALTER DATABASE ADD LOGFILE GROUP 1 SIZE 600M;

ALTER DATABASE DROP LOGFILE GROUP 2;
ALTER DATABASE ADD LOGFILE GROUP 2 SIZE 600M;

ALTER DATABASE DROP LOGFILE GROUP 3;
ALTER DATABASE ADD LOGFILE GROUP 3 SIZE 600M;