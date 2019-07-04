create table ray_bond_factor_option as select * from bond_factor_option;
--------------------------------------------------------------------------------------------------------------------
create table ray_bond_rating_model as select * from bond_rating_model;
--------------------------------------------------------------------------------------------------------------------
create table ray_lkp_ratingcd_xw as select * from lkp_ratingcd_xw;
--------------------------------------------------------------------------------------------------------------------
create table ray_user_activity as select * from user_activity;
--------------------------------------------------------------------------------------------------------------------
create table ray_rating_factor as select * from rating_factor;
--------------------------------------------------------------------------------------------------------------------
create table ray_bond_rating_factor as select * from bond_rating_factor;
--------------------------------------------------------------------------------------------------------------------
create table ray_bond_rating_record as select * from bond_rating_record;
--------------------------------------------------------------------------------------------------------------------
create table ray_bond_pledge as select * from bond_pledge;
--------------------------------------------------------------------------------------------------------------------
create table ray_bond_warrantor as select * from bond_warrantor;
--------------------------------------------------------------------------------------------------------------------
create table ray_compy_incomestate as select * from compy_incomestate;
--------------------------------------------------------------------------------------------------------------------
create table ray_lkp_finansubject_disp as select * from lkp_finansubject_disp;
--------------------------------------------------------------------------------------------------------------------
create table ray_factor_fix as select * from factor;
create table ray_element as select * from element;
--------------------------------------------------------------------------------------------------------------------
create table ray_compy_factor_finance as select * from compy_factor_finance;
create table ray_lkp_rating_code_list as select * from lkp_rating_code_list;
--------------------------------------------------------------------------------------------------------------------
ALTER SEQUENCE seq_lkp_finansubject_disp rename to ray_seq_lkp_finansubject_disp;
--------------------------------------------------------------------------------------------------------------------
-- alter view vw_bond_rating_cacul rename to ray_vw_bond_rating_cacul;
drop view vw_bond_rating_cacul;
--------------------------------------------------------------------------------------------------------------------
-- alter view vw_finance_subject rename to ray_vw_finance_subject;
--------------------------------------------------------------------------------------------------------------------
-- alter view vw_expired_rating rename to ray_vw_expired_rating;
--------------------------------------------------------------------------------------------------------------------
alter view vw_compy_creditrating_latest rename to ray_vw_compy_creditrating_latest;
--------------------------------------------------------------------------------------------------------------------
-- alter materialized view vw_compy_finanalarm rename to ray_vw_compy_finanalarm;
drop materialized view vw_compy_finanalarm;
drop view vw_finance_subject;
drop view vw_expired_rating;

---------------------------------------------------------------------------------------------------------------------
-- 检查备份对象
select count(*)
from information_schema.tables
where lower(table_schema) = lower('public')
      and upper(table_type) = upper('BASE TABLE')
      and lower(table_name) in (
  lower('ray_bond_factor_option'),
  lower('ray_bond_rating_model'),
  lower('ray_lkp_ratingcd_xw'),
  lower('ray_user_activity'),
  lower('ray_rating_factor'),
  lower('ray_bond_rating_factor'),
  lower('ray_bond_rating_record'),
  lower('ray_bond_pledge'),
  lower('ray_bond_warrantor'),
  lower('ray_compy_incomestate'),
  lower('ray_lkp_finansubject_disp'),
  lower('ray_factor_fix'),
  lower('ray_compy_factor_finance')
);

-- 期望值： 13

select count(*) from information_schema.sequences
where lower(sequence_schema) = lower('public')
  and lower(sequence_name) in (lower('ray_seq_lkp_finansubject_disp'));
-- 期望值： 1

select count(*) from information_schema.views
where lower(table_schema) = lower('public')
   and lower(table_name) in (
--       lower('ray_vw_bond_rating_cacul'),
-- lower('ray_vw_finance_subjec'),
-- lower('ray_vw_expired_rating'),
lower('ray_vw_compy_creditrating_latest'));
-- 期望值： 1

-- select count(*) from pg_matviews
-- where lower(schemaname) = lower('public')
-- and lower(matviewname) in (lower('ray_vw_compy_finanalarm'));
-- 期望值： 1
-------------------------------------------------------------
drop table if exists warning_regulation_0330;
drop table if exists bond_factor_option;
drop table if exists bond_rating_model;
drop table if exists lkp_ratingcd_xw;
drop table if exists user_activity;
drop table if exists rating_factor;
drop table if exists bond_rating_factor;
drop table if exists bond_rating_record;
drop table if exists bond_pledge;
drop table if exists bond_warrantor;
drop table if exists compy_incomestate;

-- 序列化版本
delete from oauth_access_token where 1 = 1;
