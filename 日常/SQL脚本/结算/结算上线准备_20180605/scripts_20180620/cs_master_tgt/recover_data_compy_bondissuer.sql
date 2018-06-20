delete from compy_bondissuer where 1 = 1;
commit

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
