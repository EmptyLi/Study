保证 企业3有2015年12月31日的参考评级，推送该企业 2016年12月31日缺失的财务数据
（缺失率小于40%）+2016年完整的经营数据并入模指标）推送：
净资产收益率 --- Profitability3
销售获现比率 --- Operation13 --- 缺失
有息债务/EBITDA --- Leverage18 分母小于0， 分子大于0， Case2
经营活动产生的现金流量净额 --- Size10 --- 缺失
所有者权益 --- Size2
有息债务/(有息债务+所有者权益) --- Structure2
广州医药集团有限公司

select * from compy_basicinfo where company_nm = '广州医药集团有限公司';
363605

-- 经营活动产生的现金流量净额 --- Size10 --- 缺失
select net_operate_cashflow from compy_finance where company_id = 363605 and rpt_dt = date '2016-12-31';
update compy_finance
set net_operate_cashflow = null,
  updt_dt = now()
where company_id = 363605
      and rpt_dt = date '2016-12-31';

update compy_factor_finance
set factor_value = null,
  updt_dt        = now()
where company_id = 363605
      and rpt_dt = date '2016-12-31'
      and factor_cd = 'Size10';

-- 销售获现比率 --- Operation13 --- 缺失
Operation13 入模
Operation15 销售商品、提供劳务收到的现金/购买商品、接受劳务支付的现金  没有入模

select salegoods_service_rec from compy_finance where company_id = 363605 and rpt_dt = date '2016-12-31';

update compy_finance
set salegoods_service_rec = null,
  updt_dt = now()
where company_id = 363605
      and rpt_dt = date '2016-12-31';

update compy_factor_finance
set factor_value = null,
  updt_dt        = now()
where company_id = 363605
      and rpt_dt = date '2016-12-31'
      and factor_cd = 'Operation13';

-- 有息债务/EBITDA --- Leverage18 分母小于0， 分子大于0， Case2
select ebitda from compy_finance where company_id = 363605 and rpt_dt = date '2016-12-31';

update compy_finance
set salegoods_service_rec = null,
  updt_dt = now()
where company_id = 363605
      and rpt_dt = date '2016-12-31';


-- 更新数据
update compy_factor_finance set updt_dt = now() where company_id = 363605 and rpt_dt = date'2016-12-31';
update compy_finance set updt_dt = now() where company_id = 363605 and rpt_dt = date'2016-12-31';
update compy_finance_last_y set updt_dt = now() where company_id = 363605 and rpt_dt = date'2016-12-31';
update compy_finance_bf_last_y set updt_dt = now() where company_id = 363605 and rpt_dt = date'2016-12-31';
update compy_factor_operation_expert set updt_dt = now() where company_id = 363605 and rpt_dt = date'2016-12-31';
