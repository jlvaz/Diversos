CREATE OR REPLACE FUNCTION get_used_memory RETURN NUMBER IS
l_used_memory  NUMBER;
BEGIN
   SELECT ms.value 
   INTO l_used_memory
   FROM  v$mystat ms,
         v$statname  sn
   WHERE ms.statistic# = sn.statistic#
     AND sn.name = 'session pga memory';
   RETURN l_used_memory;
END get_used_memory;

SET SERVEROUTPUT ON
DECLARE
   l_recursion_level   NUMBER:= 10000;
   l_start             NUMBER;
   PROCEDURE varchar2_1 (p_varchar  IN VARCHAR2,
                         p_number   IN NUMBER) AS
   l_varchar  VARCHAR2(1) := p_varchar;						 
   BEGIN 
      IF p_number < l_recursion_level THEN    
	     varchar2_1 (l_varchar, p_number + 1);
      END IF;
   END varchar2_1;
BEGIN 
   l_start:= get_used_memory;
   varchar2_1('1',0);
   DBMS_OUTPUT.put_line('VARCHAR2_1    : ' || (get_used_memory - l_start));
END;