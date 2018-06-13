-- 2016年财务数据包括需要特殊处理的（入模指标缺失率小于40%）+2016年缺失的经营数据（入模指标）需触发参考评级自动计算
-- 保证 企业4有2015年12月31日的参考评级，推送该企业 2016年12月31日缺失的财务数据（缺失率小于40%）+2016年缺失的经营数据（入模指标）并推送：
--
-- 模型：消费品制造
-- 财务指标：
-- 有息债务/EBITDA --- Leverage18 分子=0， 分母>0, 需正常计算
-- 资产总额 --- Size1
-- 有息债务/(有息债务+所有者权益) ---Structure2
-- 营业毛利率 --- Profitability6 --- 缺失
-- 保守速动比率 --- Leverage3
-- 营业周期 --- Operation1  --- 缺失
--
-- 非财务分析：
-- 股权结构--- factor_001  ---- 2016年缺失，2015年有值
-- 融资渠道多样性 --- factor_004
-- 受限货币资金占比 --- factor_012 --- 数据库中历年无值？？（不应该生成任何评级？？）
-- 市场地位 --- factor_071
--
--
-- 评级日期： 2016-12-31
-- 企业名称：际华集团股份有限公司
-- 企业ID: 378975

set time zone 'PRC';
select * from compy_basicinfo where company_nm = '际华集团股份有限公司'

truncate table ray_factor_list;
INSERT INTO public.ray_factor_list VALUES ('Leverage18');
INSERT INTO public.ray_factor_list VALUES ('Leverage3');
INSERT INTO public.ray_factor_list VALUES ('Operation1');
INSERT INTO public.ray_factor_list VALUES ('Profitability6');
INSERT INTO public.ray_factor_list VALUES ('Size1');
INSERT INTO public.ray_factor_list VALUES ('Structure2');
INSERT INTO public.ray_factor_list VALUES ('factor_001');
INSERT INTO public.ray_factor_list VALUES ('factor_004');
INSERT INTO public.ray_factor_list VALUES ('factor_012');
INSERT INTO public.ray_factor_list VALUES ('factor_071');
commit;


非财务分析：
-- 股权结构--- factor_001  ---- 2016年缺失，2015年有值
delete from compy_factor_operation_expert where company_id =378975 and factor_cd = 'factor_001' and extract(year from rpt_dt) = 2016 and client_id = 1;
update compy_factor_operation_expert
set updt_dt = now()
where company_id =378975 and factor_cd = 'factor_001' and extract(year from rpt_dt) = 2015 and client_id = 1;

-- 融资渠道多样性 --- factor_004
update compy_factor_operation_expert
set updt_dt = now()
where company_id =378975 and factor_cd = 'factor_004' and client_id = 1;
-- 受限货币资金占比 --- factor_012 --- 数据库中历年无值？？（不应该生成任何评级？？）
delete from compy_factor_operation_expert
where company_id =378975 and factor_cd = 'factor_012' and client_id = 1;
-- 市场地位 --- factor_071
update compy_factor_operation_expert
set updt_dt = now()
where company_id =378975 and factor_cd = 'factor_071' and client_id = 1;

-- 财务指标：
-- 有息债务/EBITDA --- Leverage18 分子=0， 分母>0, 需正常计算
update compy_factor_finance
  set  factor_value = 0,
  updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and factor_cd = 'Leverage18'
and rpt_timetype_cd = 1;

update compy_finance
    set updt_dt = now(),
      ebitda = ebitda * -1
where  company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance
set updt_dt            = now(),
  sum_lliab            = 0, account_pay = 0, advance_receive = 0, salary_pay = 0, tax_pay = 0, other_pay = 0,
  accrue_expense       = 0, defer_income_oneyear = 0
  , other_lliab        = 0, bond_pay = 0, lt_borrow = 0
where company_id = 378975
      and rpt_dt = date '2016-12-31'
      and rpt_timetype_cd = 1;

-- 营业周期 --- Operation1  --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and factor_cd = 'Leverage3'
and rpt_timetype_cd = 1;

update compy_finance
set inventory =null,
  updt_dt = now()
where  company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;


-- 保守速动比率 --- Leverage3 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and factor_cd = 'Leverage3'
and rpt_timetype_cd = 1;

update compy_finance
set monetary_fund =null,
  updt_dt = now()
where  company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;


-- 其他
update compy_factor_finance
set updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance
    set updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_last_y
    set updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_bf_last_y
    set updt_dt = now()
where company_id = 378975
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

commit;
