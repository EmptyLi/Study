create table if not exists user_activity
(
  user_activity_sid bigint       not null
    constraint pk_user_activity
    primary key,
  user_id           bigint       not null,
  start_dt          timestamp(6) not null,
  end_dt            timestamp(6),
  ip_addr           varchar(100),
  operate_type_cd   varchar(30),
  operate_content   text,
  isfailed          integer      not null,
  error_desc        varchar(2000),
  client_id         bigint       not null,
  updt_by           bigint       not null,
  updt_dt           timestamp(6) not null
);
delete from user_activity where 1 = 1;
insert into user_activity
   (	user_activity_sid
,	user_id
,	start_dt
,	end_dt
,	ip_addr
,	operate_type_cd
,	operate_content
,	isfailed
,	error_desc
,	client_id
,	updt_by
,	updt_dt
)
select 	user_activity_sid
,	user_id
,	start_dt
,	end_dt
,	ip_addr
,	operate_type_cd
,	operate_content
,	isfailed
,	error_desc
,	client_id
,	updt_by
,	updt_dt
 from ray_user_activity;

-- alter table ray_user_activity rename to user_activity;
commit;
