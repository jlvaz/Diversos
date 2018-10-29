select t.target_name
, t.target_type
, collection_timestamp
, message
, 'exec em_severity.delete_current_severity(''' ||
t.target_guid || ''',''' ||
metric_guid || ''',''' ||
key_value || ''')' em_severity
from sysman.mgmt_targets t
inner join
sysman.mgmt_current_severity s
on
t.target_guid = s.target_guid;


BEGIN

   FOR i IN (SELECT t.target_guid , metric_guid , key_value 
             FROM sysman.mgmt_targets t INNER JOIN sysman.mgmt_current_severity s
             ON t.target_guid = s.target_guid) LOOP
       execute immediate 'DELETE FROM MGMT_CURRENT_SEVERITY  WHERE target_guid = :1 AND metric_guid = :2 AND key_value = :3'
       USING i.target_guid, i.metric_guid, i.key_value;
   END LOOP;
   COMMIT;
END;
