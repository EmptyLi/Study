保证 企业2有2016年12月31日的参考(基础)评级，推送该企业 2017年12月31日完整的财务数据（入模指标）
+2017年经营数据（入模指标）缺失并推送：
set time zone 'PRC';
select * from compy_basicinfo where company_nm = '中国铁建股份有限公司';
80095

select * from compy_factor_finance where company_id = 80095 and rpt_dt = date'2017-12-31';
select * from compy_finance where company_id = 80095 and rpt_dt = date'2017-12-31';
select * from compy_finance_last_y where company_id = 80095 and rpt_dt = date'2017-12-31';
select * from compy_finance_bf_last_y where company_id = 80095 and rpt_dt = date'2017-12-31';

update compy_factor_finance set updt_dt = now() where company_id = 80095 and rpt_dt = date'2017-12-31';
update compy_finance set updt_dt = now() where company_id = 80095 and rpt_dt = date'2017-12-31';
update compy_finance_last_y set updt_dt = now() where company_id = 80095 and rpt_dt = date'2017-12-31';
update compy_finance_bf_last_y set updt_dt = now() where company_id = 80095 and rpt_dt = date'2017-12-31';
