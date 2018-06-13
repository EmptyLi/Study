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
