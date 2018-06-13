-- 1.3  2016年财务数据包括需要特殊处理的（入模指标缺失率小于40%）+2016年完整的经营数据（入模指标）需触发基础评级自动计算
--
-- 保证 企业3有2015年12月31日的参考评级，
-- 推送该企业 2016年12月31日缺失的财务数据（缺失率小于40%）+2016年完整的经营数据并入模指标）推送：
--
-- 模型：医药制造
-- 净资产收益率 --- Profitability3
-- 销售获现比率 --- Operation13 --- 缺失
-- 有息债务/EBITDA --- Leverage18 分母小于0， 分子大于0， Case2
-- 经营活动产生的现金流量净额 --- Size10 --- 缺失
-- 所有者权益 --- Size2
-- 有息债务/(有息债务+所有者权益) --- Structure2
--
-- 评级日期： 2016-12-31
-- 企业名称：广州医药集团有限公司
-- 企业ID: 363605

set time zone 'PRC';
select * from compy_basicinfo where company_nm = '广州医药集团有限公司'

truncate table ray_factor_list;
INSERT INTO public.ray_factor_list VALUES ('Leverage18');
INSERT INTO public.ray_factor_list VALUES ('Operation13');
INSERT INTO public.ray_factor_list VALUES ('Profitability3');
INSERT INTO public.ray_factor_list VALUES ('Size10');
INSERT INTO public.ray_factor_list VALUES ('Size2');
INSERT INTO public.ray_factor_list VALUES ('Structure2');
INSERT INTO public.ray_factor_list VALUES ('factor_001');
INSERT INTO public.ray_factor_list VALUES ('factor_011');
INSERT INTO public.ray_factor_list VALUES ('factor_071');
INSERT INTO public.ray_factor_list VALUES ('factor_091');
commit;

-- 查看2016年完整经营数据（入模指标）
select *
from compy_factor_operation_expert
where company_id = 363605 and rpt_dt = date '2016-12-31' and factor_cd in (select factor_cd
                                                                        from ray_factor_list);

-- 更新2016年完整经营数据（入模指标）
update compy_factor_operation_expert
  set updt_dt = now()
where company_id = 363605 and rpt_dt = date '2016-12-31' and factor_cd in (select factor_cd
                                                                        from ray_factor_list);
commit;

-- 2016年12月31日的部分财务数据
-- 销售获现比率 --- Operation13 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and factor_cd = 'Operation13'
and rpt_timetype_cd = 1;

update compy_finance
set salegoods_service_rec =null,
  updt_dt = now()
where  company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

-- 有息债务/EBITDA --- Leverage18 分母小于0， 分子大于0， Case2
update compy_factor_finance
  set  factor_value = -1.9255681708954259,
  updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and factor_cd = 'Leverage18'
and rpt_timetype_cd = 1;

update compy_finance
set updt_dt = now()
where  company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

-- 经营活动产生的现金流量净额 --- Size10 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and factor_cd = 'Size10'
and rpt_timetype_cd = 1;

update compy_finance
set net_operate_cashflow =null,
  updt_dt = now()
where  company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

-- 其他
update compy_factor_finance
set updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance
    set updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_last_y
    set updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_bf_last_y
    set updt_dt = now()
where company_id = 363605
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

commit;
