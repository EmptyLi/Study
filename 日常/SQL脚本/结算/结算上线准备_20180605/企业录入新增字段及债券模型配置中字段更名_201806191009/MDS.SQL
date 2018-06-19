select * from vw_subscribe_table_test where subscribe_table like '%COMPY_BONDISSUER%';
select * from lkp_subscribe_table where subscribe_table_id = '74423';

INSERT INTO public.lkp_subscribe_table (subscribe_table_id, subscribe_table, subscribe_desc, subscribe_level, subscribe_field_list, subscribe_filter, file_nm, stg_table, stg_field_list, tgt_table, tgt_table_type, tgt_field_list, tgt_logic_pk1, tgt_logic_pk2, tgt_physical_pk, process_type, frequency, isdel, updt_dt)
VALUES (154, 'VW_COMPY_BONDISSUER_01', '债券发行人信息表(带有更新人)', 0,
               'company_id, region, org_nature_id, actctrl_sharehd_ratio, org_nature_orig, data_src, isdel, srcid, src_cd, updt_by, updt_dt',
               null, 'COMPY_BONDISSUER', 'STG_COMPY_BONDISSUER',
               'record_sid,company_id, region, org_nature_id, actctrl_sharehd_ratio, org_nature_orig, data_src, isdel, srcid, src_cd, updt_by, updt_dt, loadlog_sid',
               'COMPY_BONDISSUER', 0,
        'company_id, region, org_nature_id, actctrl_sharehd_ratio, org_nature_orig, data_src, isdel, srcid, src_cd, updt_by, updt_dt',
        'company_id', 'company_id', 'company_id', 1, 'DAILY', 0, now());

select * from lkp_subscribe_table where subscribe_table_id = 154;

update subscribe_table_test
set subscribe_table_id = 154,
    updt_dt = now()
where subscribe_id = 1 and subscribe_table_id = 74423;

select * from vw_subscribe_table_test where subscribe_table like '%COMPY_BONDISSUER%';

select * from environment;

create view vw_compy_bondissuer_01 as
  SELECT
    compy_bondissuer.company_id,
    compy_bondissuer.region,
    compy_bondissuer.org_nature_id,
    compy_bondissuer.actctrl_sharehd_ratio,
    compy_bondissuer.org_nature_orig,
    compy_bondissuer.data_src,
    compy_bondissuer.isdel,
    compy_bondissuer.srcid,
    compy_bondissuer.src_cd,
    0 as updt_by,
    compy_bondissuer.updt_dt
  FROM compy_bondissuer;
