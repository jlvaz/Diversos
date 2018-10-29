 TRUNCATE TABLE chained_rows;
 
 ANALYZE TABLE <<table_name>> LIST CHAINED ROWS;
 
 SELECT * FROM chained_rows;
 
 alter table <table_name> move pctfree 20;
 
 alter table <table_name> move tablespace <tablespace_name>
 
 
SELECT 'alter index '||OWNER||'.'||INDEX_NAME||' rebuild;'FROM DBA_INDEXES where TABLE_NAME='FLAN' AND STATUS = 'UNUSABLE';
 
BEGIN
   DBMS_STATS.GATHER_TABLE_STATS('<owner>','<table_name>');
END;