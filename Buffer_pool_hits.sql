CREATE OR REPLACE FORCE VIEW SYSTEM.BUFFER_POOL_HITS
(NAME, BLOCK_SIZE, HIT_RATIO)
AS 
SELECT NAME, TO_CHAR (block_size / 1024) || 'k' AS "BLOCK_SIZE",
       1 - (physical_reads / (db_block_gets + consistent_gets)) AS "HIT_RATIO"
  FROM v$buffer_pool_statistics
 WHERE db_block_gets + consistent_gets > 0;

CREATE PUBLIC SYNONYM BUFFER_POOL_HITS FOR SYSTEM.BUFFER_POOL_HITS;


CREATE TABLE temp1 TABLESPACE tools AS
SELECT   
/* ©2004 by Edward Stoever, edward@database-expert.com */ 
         o.owner owner, 
         o.object_name object_name,
         o.subobject_name subobject_name, 
         o.object_type object_type,
         COUNT(DISTINCT FILE# || BLOCK#) num_blocks, 
         s.tablespace_name tablespace_name,
         s.buffer_pool buffer_pool
    FROM DBA_SEGMENTS s, DBA_OBJECTS o, v$bh bh
   WHERE o.data_object_id = bh.objd
     AND s.segment_name = o.object_name
     AND o.owner NOT IN ('SYS', 'SYSTEM')
     AND bh.status != 'free'
GROUP BY o.owner,
         o.object_name,
         o.subobject_name,
         o.object_type,
         s.tablespace_name,
         s.BUFFER_POOL
ORDER BY COUNT (DISTINCT FILE# || BLOCK#) DESC;