delete from stg_compy_bondissuer where 1 = 1;
insert into stg_compy_bondissuer
(
  record_sid            ,
  company_id            ,
  region                ,
  org_nature_id         ,
  actctrl_sharehd_ratio ,
  org_nature_orig       ,
  data_src              ,
  isdel                 ,
  srcid                 ,
  src_cd                ,
  updt_by               ,
  updt_dt               ,
  loadlog_sid
)
select
record_sid            ,
company_id            ,
region                ,
org_nature_id         ,
actctrl_sharehd_ratio ,
org_nature_orig       ,
data_src              ,
isdel                 ,
srcid                 ,
src_cd                ,
0 as updt_by          ,
updt_dt               ,
loadlog_sid
from ray_stg_compy_bondissuer;
;
commit;
