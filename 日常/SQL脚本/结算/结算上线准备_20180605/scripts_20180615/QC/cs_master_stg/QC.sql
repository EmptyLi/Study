--检查表
select table_name
from information_schema.tables
where table_schema = 'public' and table_name in ('stg_compy_incomestate',
                                                 'hist_compy_incomestate',
                                                 'stg_bond_warrantor',
                                                 'stg_bond_pledge',
                                                 'hist_bond_warrantor',
                                                 'hist_bond_pledge')

-- stg_compy_incomestate
-- hist_compy_incomestate
-- stg_bond_warrantor
-- stg_bond_pledge
-- hist_bond_warrantor
-- hist_bond_pledge


--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from stg_compy_incomestate limit 1;
--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from hist_compy_incomestate limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from stg_bond_warrantor limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from stg_bond_pledge limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from hist_bond_warrantor limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from hist_bond_pledge limit 1;



-- 检查数据量 hist_bond_pledge, 数据表与备份表数据量一致
select count(*) from hist_bond_pledge;
select count(*) from ray_hist_bond_pledge;
-- 检查数据量 hist_bond_warrantor, 数据表与备份表数据量一致
select count(*) from hist_bond_warrantor;
select count(*) from ray_hist_bond_warrantor;
-- 检查数据量 stg_bond_pledge, 数据表与备份表数据量一致
select count(*) from stg_bond_pledge;
select count(*) from ray_stg_bond_pledge;
-- 检查数据量 stg_bond_warrantor, 数据表与备份表数据量一致
select count(*) from stg_bond_warrantor;
select count(*) from ray_stg_bond_warrantor;

-- 检查函数
select count(*) from information_schema.routines where routine_schema = 'public'
and routine_name = 'fn_compy_finance_check';
-- 期望值： 1
