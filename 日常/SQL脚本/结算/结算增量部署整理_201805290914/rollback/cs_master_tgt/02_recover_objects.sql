-- 新创建的表，只有初始化
drop table if exists lkp_model_bond_type;
commit;

alter table ray_bond_rating_record rename to bond_rating_record;
commit;
alter table ray_bond_rating_factor rename to bond_rating_factor;
commit;
alter table ray_rating_factor rename to rating_factor;
commit;
alter table ray_bond_factor_option rename to bond_factor_option;
commit;

-- 需要恢复数据
alter table ray_bond_rating_model rename to bond_rating_model;
commit;

-- 分两部分恢复
alter table ray_lkp_ratingcd_xw rename to lkp_ratingcd_xw;
commit;

-- 需要恢复数据
alter table ray_bond_pledge rename to bond_pledge;
commit;

-- 需要恢复数据
alter table ray_bond_warrantor rename to bond_warrantor;
commit;

-- 视图不需要修复
alter view ray_vw_bond_rating_cacul rename to vw_bond_rating_cacul;
commit;

-- 不需要恢复
drop table if exists ray_lkp_finansubject_disp;
commit;

alter index ray_pk_bond_pledge rename to pk_bond_pledge;
commit;

alter index ray_pk_bond_warrantor rename to pk_bond_warrantor;
commit;

alter index ray_pk_lkp_ratingcd_xw rename to pk_lkp_ratingcd_xw;
commit;

alter index ray_pk_bond_rating_model rename to pk_bond_rating_model;
commit;
alter index ray_pk_bond_rating_record rename to pk_bond_rating_record;
commit;
alter index ray_pk_bond_rating_factor rename to pk_bond_rating_factor;
commit;

alter index rating_hist_factor_score_pk rename to rating_hist_factor_score_pkey;
commit;
alter index ray_pk_bond_factor_option rename to pk_bond_factor_option;
commit;

-- 如果不存在则
drop view vw_bond_rating_cacul_pledge;
commit;

drop view vw_bond_rating_cacul_warrantor;
commit;
