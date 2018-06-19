select * from stg_compy_bondissuer

create table ray_stg_compy_bondissuer as select * from stg_compy_bondissuer;
drop table stg_compy_bondissuer;
create table stg_compy_bondissuer
(
  record_sid            bigint default nextval('seq_stg_compy_bondissuer' :: regclass),
  company_id            bigint       not null,
  region                integer      not null,
  org_nature_id         bigint,
  actctrl_sharehd_ratio numeric(20, 4),
  org_nature_orig       varchar(4000),
  data_src              varchar(1000),
  isdel                 integer      not null,
  srcid                 varchar(100) not null,
  src_cd                varchar(10)  not null,
  updt_by               integer      not null,
  updt_dt               timestamp(6) not null,
  loadlog_sid           bigint
);

-- select setval('seq_stg_compy_bondissuer',case when max(record_sid :: bigint) > max(start_value :: bigint)
--   then max(record_sid :: bigint)
--        else max(start_value :: bigint) end)
-- from ray_stg_compy_bondissuer
--   inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_stg_compy_bondissuer';

select * from hist_compy_bondissuer;
create table ray_hist_compy_bondissuer as select * from hist_compy_bondissuer;
drop table hist_compy_bondissuer;
create table hist_compy_bondissuer
(
  record_sid            bigint,
  company_id            bigint,
  region                integer,
  org_nature_id         bigint,
  actctrl_sharehd_ratio numeric(20, 4),
  org_nature_orig       varchar(4000),
  data_src              varchar(1000),
  isdel                 integer,
  srcid                 varchar(100),
  src_cd                varchar(10),
  updt_by               integer,
  updt_dt               timestamp(6),
  loadlog_sid           bigint
);

  insert into hist_compy_bondissuer
      select record_sid
,company_id
,region
,org_nature_id
,actctrl_sharehd_ratio
,org_nature_orig
,data_src
,isdel
,srcid
,src_cd
,0 as updt_by
,updt_dt
,loadlog_sid
from ray_hist_compy_bondissuer;
