How to find v$session_wait object names ? 

select	b.sid,
	substr(a.segment_name,1,25) OBJ_NAME,
	a.segment_type OBJ_TYPE,
	b.p2 BLOCKID,
	b.p3 BLOCKS,
	b.event
from	dba_extents a,
	v$session_wait b
where	b.p2 between a.block_id AND (a.block_id+a.blocks) 
and	a.file_id = b.p1
and	b.p1text='file#'
and	b. event like 'db file%'