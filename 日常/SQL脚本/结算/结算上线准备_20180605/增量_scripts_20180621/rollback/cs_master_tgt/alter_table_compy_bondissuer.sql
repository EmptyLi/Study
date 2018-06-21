drop table if exists compy_bondissuer;
create table if not exists compy_bondissuer
(
  company_id            bigint       not null,
  region                integer      not null,
  org_nature_id         bigint,
  actctrl_sharehd_ratio numeric(20, 4),
  org_nature_orig       varchar(4000),
  data_src              varchar(1000),
  isdel                 integer      not null,
  srcid                 varchar(100) not null,
  src_cd                varchar(10)  not null,
  -- updt_by               integer      not null,
  updt_dt               timestamp    not null
);
commit;

insert into compy_bondissuer
(company_id
,region
,org_nature_id
,actctrl_sharehd_ratio
,org_nature_orig
,data_src
,isdel
,srcid
,src_cd
,updt_by
,updt_dt)
    select company_id
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
from ray_compy_bondissuer;
commit;
