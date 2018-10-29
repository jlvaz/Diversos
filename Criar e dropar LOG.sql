alter database drop logfile group <group number>

alter database add logfile group <group number> SIZE 1000M;

No caso do log ser o corrente faça o seguinte :

alter system switch logfile

ALTER DATABASE CLEAR UNARCHIVED LOGFILE GROUP <current log>