--Script used to re-grant privilege after revoking from public

select unique statements from 
    ( 
     select nvl2(p.grantee,'-- ','')||'grant execute on '|| d.referenced_name||' to '||d.owner||';' statements 
     from dba_dependencies d left join dba_tab_privs p 
       on d.owner=p.grantee and p.privilege='EXECUTE' and d.referenced_name=p.table_name 
     where d.referenced_owner in ('SYS','PUBLIC') 
       and d.referenced_type in ('PACKAGE','SYNONYM') 
       and d.referenced_name in 
       ( 
     'DBMS_RANDOM', 
     'DBMS_EXPORT_EXTENSION', 
     'UTL_FILE', 
     'DBMS_JOB', 
     'DBMS_LOB', 
     'UTL_SMTP', 
     'UTL_TCP', 
     'UTL_HTTP' 
     ) 
  and d.owner <> 'SYS' 
  and d.owner <> 'PUBLIC' 
  ) 
  order by replace(statements,'-- ','') 
  /