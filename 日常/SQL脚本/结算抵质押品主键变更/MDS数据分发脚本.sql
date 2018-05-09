INSERT INTO public.lkp_subscribe_table
(subscribe_table_id,
 subscribe_table,
 subscribe_desc,
 subscribe_level,
 subscribe_field_list,
 subscribe_filter,
 file_nm,
 stg_table,
 stg_field_list,
 tgt_table,
 tgt_table_type,
 tgt_field_list,
 tgt_logic_pk1,
 tgt_logic_pk2,
 tgt_physical_pk,
 process_type,
 frequency,
 isdel,
 updt_dt)
VALUES (152,
  'VW_BOND_PLEDGE_01',
  '债券抵质押品表(带报告期)',
  0,
  'bond_pledge_sid, secinner_id, rpt_dt, notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, 0 as updt_by, updt_dt',
  NULL,
  'BOND_PLEDGE',
  'STG_BOND_PLEDGE',
  'record_sid,bond_pledge_sid, secinner_id,rpt_dt, notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt,loadlog_sid',
  'BOND_PLEDGE',
  0,
        'bond_pledge_sid, secinner_id, rpt_dt, notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt',
        'secinner_id, rpt_dt, pledge_nm',
        'secinner_id,rpt_dt,pledge_nm',
        'bond_pledge_sid',
        4,
        'DAILY',
        0,
        '2018-05-04 17:21:09.532400');
commit;

select * from lkp_subscribe_table where subscribe_table = 'VW_BOND_PLEDGE_01';
create table subscribe_table_uat as select * from subscribe_table where subscribe_table_id = 116;
delete from subscribe_table_uat where subscribe_id <> 1;
update subscribe_table_uat set subscribe_table_id = 152;
select * from subscribe_table_uat;
commit;

CREATE OR REPLACE VIEW "public".vw_subscribe_table_uat AS  SELECT a.subscribe_table_id,
    a.subscribe_id,
    COALESCE(a.subscribe_filter, b.subscribe_filter) AS subscribe_filter,
    a.if_prior,
    COALESCE(a.subscribe_table, b.subscribe_table) AS subscribe_table,
    b.subscribe_desc,
    b.subscribe_field_list,
    b.subscribe_level,
    b.file_nm,
    b.stg_table,
    b.stg_field_list,
    b.tgt_table,
    b.tgt_table_type,
    b.tgt_field_list,
    b.tgt_logic_pk1,
    b.tgt_logic_pk2,
    b.tgt_physical_pk,
    b.process_type,
    COALESCE(a.frequency, b.frequency) AS frequency,
    a.client_id,
    GREATEST(a.isdel, b.isdel) AS isdel,
    GREATEST(COALESCE(a.updt_dt, (to_date('1900-01-01'::text, 'YYYY-MM-DD'::text))::timestamp without time zone), COALESCE(b.updt_dt, (to_date('1900-01-01'::text, 'YYYY-MM-DD'::text))::timestamp without time zone)) AS updt_dt
   FROM (subscribe_table_uat a
     JOIN lkp_subscribe_table b ON ((a.subscribe_table_id = b.subscribe_table_id)));
;
commit;

select * from vw_subscribe_table_uat;
update environment
set subscribe_view = 'vw_subscribe_table_uat',
  updt_dt = now()
where environment_sid = 2;
commit;

select * from environment;
select * from etl_exp_loadlog_uat where table_nm = 'vw_bond_pledge_01';
