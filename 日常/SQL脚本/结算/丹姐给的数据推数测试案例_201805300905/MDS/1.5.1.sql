-- 保证 企业7有2015年12月31日的参考评级，推送该企业 2016年12月31日的部分财务数据（入模指标缺失大于40%）+2016年完整经营数据（入模指标）并推送：
-- 模型：医药制造
-- 财务指标：
-- 净资产收益率 --- Profitability3 --- 缺失
-- 销售获现比率 --- Operation13 --- 缺失
-- 有息债务/EBITDA --- Leverage18，
-- 经营活动产生的现金流量净额 --- Size10
-- 所有者权益 --- Size2 --- 缺失， X用0.1替换？Y=(X-avg)/std_dev
-- 有息债务/(有息债务+所有者权益) --- Structure2
--
--
-- 非财务分析：
-- 股权结构 --- factor_001   2016年
-- 应收账款账龄 --- factor_011  2016年
-- 原材料供应状况 --- factor_091  2016年
-- 市场地位 --- factor_071  2016年
--
-- 评级日期： 2016-12-31
-- 企业名称：康美药业股份有限公司
-- 企业ID: 358876
set time zone 'PRC';
select * from compy_basicinfo where company_nm = '康美药业股份有限公司'
truncate table ray_factor_list;
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
-- 非财务分析：
-- 股权结构 --- factor_001   2016年
-- 应收账款账龄 --- factor_011  2016年
-- 原材料供应状况 --- factor_091  2016年
-- 市场地位 --- factor_071  2016年
update compy_factor_operation_expert
set updt_dt = now()
where company_id =358876 and factor_cd in (select factor_cd from ray_factor_list) and extract(year from rpt_dt) = 2016 and client_id = 1;


财务指标：
净资产收益率 --- Profitability3 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 358876
and rpt_dt = date '2016-12-31'
and factor_cd = 'Profitability3'
and rpt_timetype_cd = 1;

update compy_finance
set net_profit =null,
  updt_dt = now()
where  company_id = 358876
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

销售获现比率 --- Operation13 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 358876
and rpt_dt = date '2016-12-31'
and factor_cd = 'Operation13'
and rpt_timetype_cd = 1;

update compy_finance
set salegoods_service_rec =null,
  updt_dt = now()
where  company_id = 358876
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

   所有者权益 --- Size2 --- 缺失， X用0.1替换？Y=(X-avg)/std_dev  影响 Structure2


   update compy_factor_finance
     set  factor_value = null
     updt_dt = now()
   where company_id = 358876
   and rpt_dt = date '2016-12-31'
   and factor_cd = 'Size2'
   and rpt_timetype_cd = 1;


   update compy_finance
       set updt_dt = now(),
         sum_sh_equity = null
   where  company_id = 358876
   and rpt_dt = date '2016-12-31'
   and rpt_timetype_cd = 1;
   -- 其他
   update compy_factor_finance
   set updt_dt = now()
   where factor_cd in (select factor_cd from ray_factor_list)
   and company_id = 358876
   and rpt_dt = date '2016-12-31'
   and rpt_timetype_cd = 1;

   update compy_finance
       set updt_dt = now()
   where company_id = 358876
   and rpt_dt = date '2016-12-31'
   and rpt_timetype_cd = 1;

   update compy_finance_last_y
       set updt_dt = now()
   where company_id = 358876
   and rpt_dt = date '2016-12-31'
   and rpt_timetype_cd = 1;

   update compy_finance_bf_last_y
       set updt_dt = now()
   where company_id = 358876
   and rpt_dt = date '2016-12-31'
   and rpt_timetype_cd = 1;

   commit;
