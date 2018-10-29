cd /etc

sudo vim profile   Alterar TZ=Etc/GMT+2 para TZ=Etc/GMT+3 ou vice-versa

export TZ=Etc/GMT+2  HORÁRIO DE VERÃO  ou export TZ=Etc/GMT+3 RETORNO DO HORÁRIO NORMAL (RECUANDO 1 HORA)

shutdown immediate

startup

emctl stop dbconsole

emctl resetTZ agent

Conecte-se no banco como  'sys', e execute:


SQL> alter session set current_schema = SYSMAN;


SQL> exec mgmt_target.set_agent_tzrgn('localhost.localdomain:3938','Etc/GMT+3');  RETORNO DO HORÁRIO NORMAL (RECUANDO 1 HORA)
SQL> exec mgmt_target.set_agent_tzrgn('localhost:3938','Etc/GMT+2');  HORÁRIO DE VERÃO
SQL> commit;

emctl start dbconsole;

sqlplus "/as sysdba"  /  shutdown immediate / startup
