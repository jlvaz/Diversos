
SELECT * FROM ALL_DB_LINKS


NO SCHEMA SYSPERGAMUM

CREATE DATABASE LINK DBLINK_SYSPERGAMUM 
       CONNECT TO "universus" IDENTIFIED BY "7A30B86943" USING 'dbfeso1';


NO SCHEMA UNIVERSUS

CREATE DATABASE LINK DBLINK_UNIVERSUS
       CONNECT TO "SYSPERGAMUM" IDENTIFIED BY "98ZK3R6E4" USING 'dbfeso1';

