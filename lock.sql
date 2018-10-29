sessão que mantém objeto locado

select substr(o.object_name,1,25) 	objeto,
      l.session_id 			session_id,
      l.oracle_username		ora_user,
      l.os_user_name			os_user
from   dba_objects o, v$locked_object l
where  l.object_id = o.object_id
order by 1,3,4


select     p.spid,
    s.username,
    s.osuser,
    s.machine,
    p.program,
    l.lmode,
    l.block
from     v$session s,
    v$process p,
    v$lock l
WHERE  s.paddr = p.addr
AND    l.sid = s.sid
AND    s.username IS NOT NULL


select l1.sid, ' IS BLOCKING ', l2.sid
    from v$lock l1, v$lock l2
    WHERE l1.block =1 AND l2.request > 0
    AND l1.id1=l2.id1
    AND l1.id2=l2.id2
    
select vs1.username || ' Máquina ' || vs1.machine || 'PROGRAM ' ||  vs1.program || ' ( SID=' || vs1.sid || '  ' || ' SERIAL= ' || vs1.serial# || ' )  está bloqueando '
    || vs2.username || ' Máquina ' || vs2.machine || 'PROGRAM ' ||  vs1.program || ' ( SID=' || vs2.sid || '  ' || ' SERIAL= ' || vs2.serial# || ' ) '
    || chr(10) || chr(13) 
    || ' SQL ' || vsql.sql_text 
    || ' EVENTO ' || vs1.event
    || ' DATA DO OCORRIDO ' || SYSDATE
    from v$lock l1, v$session vs1, v$lock l2, v$session vs2, v$sql vsql
    WHERE vs1.sid=l1.sid 
    AND   vs2.sid=l2.sid 
    AND   l1.BLOCK=1 
    AND   l2.request > 0
    AND   l1.id1 = l2.id1
    AND   l2.id2 = l1.id2
    AND   vs1.sql_id = vsql.sql_id
	
select object_name from dba_objects WHERE object_id=<id1> ;


select row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row#
   from v$session WHERE sid=<SID> ;
   
select do.object_name,
    row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row#,
    dbms_rowid.rowid_create ( 1, ROW_WAIT_OBJ#, ROW_WAIT_FILE#, ROW_WAIT_BLOCK#, ROW_WAIT_ROW# )
    from v$session s, dba_objects do
    WHERE sid=<sid>
    AND s.ROW_WAIT_OBJ# = do.OBJECT_ID ;
	
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