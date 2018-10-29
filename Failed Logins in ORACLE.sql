CREATE OR REPLACE TRIGGER SYS.AUTH_LOGIN
AFTER servererror on database
BEGIN
   IF (ORA_IS_SERVERERROR(1017)) Then 
       INSERT INTO T_FAILED_LOGINS_UNIFESO 
              VALUES (SYS_CONTEXT('USERENV','AUTHENTICATED_IDENTITY'), 
                      SYS_CONTEXT('USERENV', 'OS_USER') ,
                      USERENV('TERMINAL'), 
                      SYS_CONTEXT ('USERENV', 'IP_ADDRESS'), 
                      SYS_CONTEXT ('USERENV', 'MODULE'), SYSDATE);
   END IF;
End;
