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

xec EM_SEVERITY.delete_current_severity(TARGET_GUID,METRIC_GUID,KEY_VALUE);

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','UNIVERSUS')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','PUBLIC')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','SITE')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','RM')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','SCAPP')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','SYSPERGAMUM')

exec em_severity.delete_current_severity('3151B19C3343D27A6DA457516A6D092C','F95BA0D95585002889E1ABF92B2DA7C3','AVALIACAO')