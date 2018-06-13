-- 保证 企业6有2015年12月31日的参考评级，推送该企业 2016年12月31日的部分财务数据（入模指标缺失等于40%）+2016年经营数据（入模指标）缺失并推送：
-- 模型：公用事业
-- 财务指标：
-- 有息债务/EBITDA --- Leverage18， 分母小于0， 分子小于0， case5, 正常计算
-- 所有者权益 --- Size2
-- 净资产收益率 --- Profitability3 --- 缺失
-- 短期有息债务/有息债务 --- Structure19
-- 销售获现比率 --- Operation13 --- 缺失
--
-- 非财务分析：
-- 股权结构 --- factor_001   2015年
-- 融资渠道多样性 --- factor_004  2016年
-- 对外担保占比 --- factor_008 2015年
-- 服务能力 --- factor_079 2014年
--
-- 评级日期： 2016-12-31
-- 企业名称：四川川投能源股份有限公司
-- 企业ID: 347
set time zone 'PRC';
truncate table ray_factor_list;
INSERT INTO public.ray_factor_list VALUES ('Leverage18');
INSERT INTO public.ray_factor_list VALUES ('Operation13');
INSERT INTO public.ray_factor_list VALUES ('Profitability3');
INSERT INTO public.ray_factor_list VALUES ('Size2');
INSERT INTO public.ray_factor_list VALUES ('Structure19');
INSERT INTO public.ray_factor_list VALUES ('factor_001');
INSERT INTO public.ray_factor_list VALUES ('factor_004');
INSERT INTO public.ray_factor_list VALUES ('factor_008');
INSERT INTO public.ray_factor_list VALUES ('factor_079');
commit;

非财务分析：
-- 股权结构 --- factor_001   2015年
update compy_factor_operation_expert
set updt_dt = now()
where company_id =347 and factor_cd = 'factor_001' and extract(year from rpt_dt) = 2015 and client_id = 1;

-- 融资渠道多样性 --- factor_004  2016年
update compy_factor_operation_expert
set updt_dt = now()
where company_id =347 and factor_cd = 'factor_004' and extract(year from rpt_dt) = 2016 and client_id = 1;
-- 对外担保占比 --- factor_008 2015年
update compy_factor_operation_expert
set updt_dt = now()
where company_id =347 and factor_cd = 'factor_008' and extract(year from rpt_dt) = 2015 and client_id = 1;
-- 服务能力 --- factor_079 2014年
update compy_factor_operation_expert
set updt_dt = now()
where company_id =347 and factor_cd = 'factor_079' and extract(year from rpt_dt) = 2014 and client_id = 1;



财务指标：
有息债务/EBITDA --- Leverage18， 分母小于0， 分子小于0， case5, 正常计算

update compy_finance
    set updt_dt = now(),
      ebitda = ebitda * -1
where  company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance
set updt_dt            = now(),
  lt_borrow = lt_borrow - 10000000000
where company_id = 378975
      and rpt_dt = date '2016-12-31'
      and rpt_timetype_cd = 1;


净资产收益率 --- Profitability3 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 347
and rpt_dt = date '2016-12-31'
and factor_cd = 'Profitability3'
and rpt_timetype_cd = 1;

update compy_finance
set net_profit =null,
  updt_dt = now()
where  company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;


销售获现比率 --- Operation13 --- 缺失
update compy_factor_finance
  set  factor_value = null,
  updt_dt = now()
where company_id = 347
and rpt_dt = date '2016-12-31'
and factor_cd = 'Operation13'
and rpt_timetype_cd = 1;

update compy_finance
set salegoods_service_rec =null,
  updt_dt = now()
where  company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;


-- 其他
update compy_factor_finance
set updt_dt = now()
where factor_cd in (select factor_cd from ray_factor_list) and factor_cd not in ('Operation13', 'Profitability3', 'Leverage18')
and company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance
    set updt_dt = now()
where company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_last_y
    set updt_dt = now()
where company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

update compy_finance_bf_last_y
    set updt_dt = now()
where company_id = 347
and rpt_dt = date '2016-12-31'
and rpt_timetype_cd = 1;

commit;
