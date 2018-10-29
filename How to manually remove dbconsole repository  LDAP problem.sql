How to manually remove dbconsole repository?


exec DBMS_AQADM.DROP_QUEUE_TABLE(queue_table=>'SYSMAN.MGMT_NOTIFY_QTABLE',force=>TRUE);
REM Drop the sysman account and management objects:

SHUTDOWN IMMEDIATE;
STARTUP RESTRICT; *******
EXEC sysman.emd_maintenance.remove_em_dbms_jobs;
EXEC sysman.setEMUserContext('',5);
REVOKE dba FROM sysman; ******
DECLARE
 CURSOR c1 IS
 SELECT owner, synonym_name name
 FROM dba_synonyms
 WHERE table_owner = 'SYSMAN';

 BEGIN
 FOR r1 IN c1
 LOOP
 IF r1.owner = 'PUBLIC' THEN
 EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM '||r1.name;
 ELSE
 EXECUTE IMMEDIATE 'DROP SYNONYM '||r1.owner||'.'||r1.name;
 END IF;
 END LOOP;
END;
 /

DROP ROLE mgmt_user;
DROP user mgmt_view cascade;
DROP user sysman cascade;
ALTER SYSTEM DISABLE RESTRICTED SESSION;

Verify the sysman is dropped

select username, account_status, created from dba_users where username in ('SYSMAN');


How to DROP DBConsole configuration files using EMCA (leave repository intact) ? 
$ORACLE_HOME/bin/emca -deconfig dbcontrol db

--
-- início da opção abaixo é para o repositório inexistente   ---  How to DROP DBConsole using EMCA or manually (with and without repository)   Utilizado com o problema do LDAP
--

$ORACLE_HOME/bin/emca -deconfig dbcontrol db -repos drop

--
-- fim da opção abaixo é para o repositório inexistente
--

How to configure/CREATE DBConsole along with the repository?
$ORACLE_HOME/bin/emca -config dbcontrol db -repos create

How to RE-CREATE DBConsole using EMCA? (files and repository using a single command)
$ORACLE_HOME/bin/emca -config dbcontrol db -repos recreate

How to CREATE DBConsole configuration files?
$ORACLE_HOME/bin/emca -config dbcontrol db


1) Set the environment variable ORACLE_SID to (dbfeso......)
2) /u01/app/oracle/product/11.2.0/db_1/bin/emctl stop dbconsole
3) /u01/app/oracle/product/11.2.0/db_1/bin/emctl config emkey -repos -sysman_pwd < Password for SYSMAN user >  
4) /u01/app/oracle/product/11.2.0/db_1/bin/emctl secure dbconsole -sysman_pwd < Password for SYSMAN user >  
5) /u01/app/oracle/product/11.2.0/db_1/bin/emctl start dbconsole


https://10.1.0.33:5500/em - bdteste

https://localhost.localdomain:5503/em  - dbfeso211G


