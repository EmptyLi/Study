-- 备份表结构及数据 hist_bond_pledge
create table ray_hist_bond_pledge as select * from hist_bond_pledge;
drop table hist_bond_pledge;
-- alter table hist_bond_pledge rename to ray_hist_bond_pledge;
commit;

-- 备份表结构及数据 hist_bond_warrantor
create table ray_hist_bond_pledge as select * from hist_bond_pledge;
drop table hist_bond_pledge;
-- alter table hist_bond_warrantor rename to ray_hist_bond_warrantor;
commit;

-- 备份表结构及数据 hist_compy_incomestate
create table ray_hist_compy_incomestate as select * from hist_compy_incomestate;
drop table hist_compy_incomestate;
-- alter table hist_compy_incomestate rename to ray_hist_compy_incomestate;
commit;

-- 备份表结构及数据 stg_bond_pledge
create table ray_stg_bond_pledge as select * from stg_bond_pledge;
drop table stg_bond_pledge;
-- alter table stg_bond_pledge rename to ray_stg_bond_pledge;
commit;

-- 备份表结构及数据 stg_bond_warrantor
create table ray_stg_bond_warrantor as select * from stg_bond_warrantor;
drop table stg_bond_warrantor;
-- alter table stg_bond_warrantor rename to ray_stg_bond_warrantor;
commit;

-- 备份表结构及数据 stg_compy_incomestate
create table ray_stg_compy_incomestate as select * from stg_compy_incomestate;
drop table stg_compy_incomestate;
-- alter table stg_compy_incomestate rename to ray_stg_compy_incomestate;
commit;

-- 备份修改的数据
create table ray_stg_lkp_finance_check_rule as
select * from stg_lkp_finance_check_rule
where check_cd='GIS01';
commit;

-- 备份对象 fn_compy_finance_check
alter function fn_compy_finance_check() rename to ray_fn_compy_finance_check;
commit;

--
create table ray_subscribe_table as
select * from subscribe_table;
commit;

create table ray_lkp_subscribe_table as
select * from lkp_subscribe_table;
commit;

----------------------------------------------------------------------------------

select count(*)
from information_schema.tables
where lower(table_schema) = lower('public')
      and upper(table_type) = upper('BASE TABLE')
      and lower(table_name) in (
  lower('ray_hist_bond_pledge'),
  lower('ray_hist_bond_pledge'),
  lower('ray_hist_compy_incomestate'),
  lower('ray_stg_bond_pledge'),
  lower('ray_stg_bond_warrantor'),
  lower('ray_stg_compy_incomestate'),
  lower('ray_stg_lkp_finance_check_rule'),
  lower('ray_subscribe_table'),
  lower('ray_lkp_subscribe_table')
);
-- 期望值： 9


select count(*) from information_schema.routines
where lower(specific_schema) = lower('public')
  and lower(routine_name) in (lower('ray_fn_compy_finance_check'));
-- 期望值： 1
