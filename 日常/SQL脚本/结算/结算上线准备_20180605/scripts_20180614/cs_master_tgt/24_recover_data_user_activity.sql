delete from user_activity where 1 =1 ;
commit;
insert into user_activity
(user_activity_sid
,user_id
,start_dt
,end_dt
,ip_addr
,operate_type_cd
,operate_content
,isfailed
,error_desc
,client_id
,updt_by
,updt_dt)
select
user_activity_sid
,user_id
,start_dt
,end_dt
,ip_addr
,operate_type_cd
,operate_content
,isfailed
,error_desc
,client_id
,updt_by
,updt_dt
from ray_user_activity;
commit;
