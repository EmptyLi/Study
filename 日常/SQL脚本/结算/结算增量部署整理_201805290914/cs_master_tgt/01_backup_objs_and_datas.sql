-- 新创建的表，只有初始化
-- alter table lkp_model_bond_type rename to ray_lkp_model_bond_type;
-- commit;

alter table bond_rating_record rename to ray_bond_rating_record;
commit;
alter table bond_rating_factor rename to ray_bond_rating_factor;
commit;
alter table rating_factor rename to ray_rating_factor;
commit;
alter table bond_factor_option rename to ray_bond_factor_option;
commit;

-- 需要恢复数据
alter table bond_rating_model rename to ray_bond_rating_model;
commit;

-- 分两部分恢复
alter table lkp_ratingcd_xw rename to ray_lkp_ratingcd_xw;
commit;

-- 需要恢复数据
alter table bond_pledge rename to ray_bond_pledge;
commit;

-- 需要恢复数据
alter table bond_warrantor rename to ray_bond_warrantor;
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
alter index rating_hist_factor_score_pkey rename to ray_rating_hist_factor_score_pk;
commit;
alter index pk_bond_factor_option rename to ray_pk_bond_factor_option;
commit;
