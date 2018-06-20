drop table if exists hist_compy_bondissuer;
create table if not exists hist_compy_bondissuer
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
  updt_dt               timestamp(6),
  loadlog_sid           bigint
);
commit;

insert into hist_compy_bondissuer
   (record_sid
,company_id
,region
,org_nature_id
,actctrl_sharehd_ratio
,org_nature_orig
,data_src
,isdel
,srcid
,src_cd
,updt_dt
,loadlog_sid)
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
,updt_dt
,loadlog_sid
from ray_hist_compy_bondissuer;
commit;
