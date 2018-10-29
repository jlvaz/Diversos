select * 
from(
   select 
      name, bytes/(1024*1024) MB 
   from 
      v$sgastat 
   where 
      pool ='shared pool' 
   order by 
      bytes desc
   ) 
where rownum < 20;