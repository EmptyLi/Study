-- 新创建的表，只有初始化
-- alter table lkp_model_bond_type rename to ray_lkp_model_bond_type;
-- commit;
create table ray_bond_rating_record as select * from bond_rating_record;
drop table bond_rating_record;
-- alter table bond_rating_record rename to ray_bond_rating_record;
commit;

create table ray_bond_rating_factor as select * from bond_rating_factor;
drop table bond_rating_factor;
-- alter table bond_rating_factor rename to ray_bond_rating_factor;
commit;

create table ray_rating_factor as select * from rating_factor;
drop table rating_factor;
-- alter table rating_factor rename to ray_rating_factor;
commit;

create table ray_bond_factor_option as select * from bond_factor_option;
drop table bond_factor_option;
-- alter table bond_factor_option rename to ray_bond_factor_option;
commit;

-- 需要恢复数据
create table ray_bond_rating_model as select * from bond_rating_model;
drop table bond_rating_model;
-- alter table bond_rating_model rename to ray_bond_rating_model;
commit;

-- 分两部分恢复
create table ray_lkp_ratingcd_xw as select * from lkp_ratingcd_xw;
drop table lkp_ratingcd_xw;
-- alter table lkp_ratingcd_xw rename to ray_lkp_ratingcd_xw;
commit;

-- 需要恢复数据
create table ray_bond_pledge as select * from bond_pledge;
drop table bond_pledge;
-- alter table bond_pledge rename to ray_bond_pledge;
commit;

-- 需要恢复数据
create table ray_bond_warrantor as select * from bond_warrantor;
drop table bond_warrantor;
-- alter table bond_warrantor rename to ray_bond_warrantor;
commit;

-- 视图不需要修复
alter view vw_bond_rating_cacul rename to ray_vw_bond_rating_cacul;
commit;

-- 不需要恢复
create table ray_lkp_finansubject_disp as select * from lkp_finansubject_disp;
commit;


alter index pk_bond_pledge rename to ray_pk_bond_pledge;
commit;

alter index pk_bond_warrantor rename to ray_pk_bond_warrantor;
commit;

alter index pk_lkp_ratingcd_xw rename to ray_pk_lkp_ratingcd_xw;
commit;

alter index pk_bond_rating_model rename to ray_pk_bond_rating_model;
commit;
alter index pk_bond_rating_record rename to ray_pk_bond_rating_record;
commit;
alter index pk_bond_rating_factor rename to ray_pk_bond_rating_factor;
commit;
--------------------------------------------------------------------------------
alter index rating_hist_factor_score_pkey rename to ray_rating_hist_factor_score_pk;
commit;
--------------------------------------------------------------------------------
alter index pk_bond_factor_option rename to ray_pk_bond_factor_option;
commit;

ALTER SEQUENCE seq_lkp_finansubject_disp rename  to ray_seq_lkp_finansubject_disp;
commit;

alter view vw_expired_rating rename to ray_vw_expired_rating;
commit;

alter view vw_finance_subject rename to ray_vw_finance_subject;
commit;

alter materialized view vw_compy_finanalarm rename to ray_vw_compy_finanalarm;
commit;

create table ray_compy_incomestate as select * from compy_incomestate;
drop table compy_incomestate;
-- alter table compy_incomestate rename to ray_compy_incomestate;
commit;

alter index pk_compy_incomestate rename to ray_pk_compy_incomestate;
commit;


create table ray_factor_fix as select * from factor;
commit;

create table ray_compy_factor_finance as select * from compy_factor_finance;
commit;

create table ray_user_activity as select * from user_activity;
commit;

alter index pk_user_activity rename to ray_pk_user_activity;
commit;
