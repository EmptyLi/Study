-- 保证 企业9有2015年12月31日的参考评级，推送该企业 2016年12月31日的完整的财务数据（入模指标）和2016年经营数据入模指标）并推送：
-- 模型：房地产
--
-- 评级日期： 2016-12-31
-- 企业名称：上海地产(集团)有限公司
-- 企业ID: 180010
set time zone 'PRC';
select * from compy_basicinfo where company_nm = '上海地产(集团)有限公司'
truncate table ray_factor_list;
INSERT INTO public.ray_factor_list VALUES ('Operation3');
INSERT INTO public.ray_factor_list VALUES ('Profitability3');
INSERT INTO public.ray_factor_list VALUES ('Size2');
INSERT INTO public.ray_factor_list VALUES ('Specific2');
INSERT INTO public.ray_factor_list VALUES ('Specific8');
INSERT INTO public.ray_factor_list VALUES ('Structure2');
INSERT INTO public.ray_factor_list VALUES ('factor_001');
INSERT INTO public.ray_factor_list VALUES ('factor_003');
INSERT INTO public.ray_factor_list VALUES ('factor_015');
INSERT INTO public.ray_factor_list VALUES ('factor_020');
INSERT INTO public.ray_factor_list VALUES ('factor_022');
commit;

-- 2016年12月31日的完整的财务数据（入模指标
update compy_factor_finance
  set  updt_dt = now()
where company_id = 180010
and rpt_dt = date '2016-12-31'
-- and factor_cd in (select factor_cd from ray_factor_list)
and rpt_timetype_cd = 1;


-- 2016年经营数据入模指标）
update compy_factor_operation_expert
set updt_dt = now()
where company_id =180010
-- and factor_cd in (select factor_cd from ray_factor_list)
and extract(year from rpt_dt) = 2013 and client_id = 1;


update compy_finance
    set updt_dt = now()
where company_id = 180010
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_last_y
    set updt_dt = now()
where company_id = 180010
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_bf_last_y
    set updt_dt = now()
where company_id = 180010
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

commit;
