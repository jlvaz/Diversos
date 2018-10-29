KILL SESSION 

begin     
    for x in (  
            select Sid, Serial#, machine, program  
            from v$session  
            where  
                username = 'RM' and machine <> 'UNIFESO\GTIC-027672'
        ) loop  
        execute immediate 'Alter System Kill Session '''|| x.Sid  
                     || ',' || x.Serial# || ''' IMMEDIATE';  
    end loop;  
end;


KILL BLOCK SESSION

begin     
    for x in (  
            select Sid, Serial#, machine, program  
            from v$session  
            where  
                username = 'RM' AND EVENT = 'enq: TX - row lock contention' and state in ('WAITING') and wait_class != 'Idle'
        ) loop  
        execute immediate 'Alter System Kill Session '''|| x.Sid  
                     || ',' || x.Serial# || ''' IMMEDIATE';  
    end loop;  
end;