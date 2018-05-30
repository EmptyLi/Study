-- 清理已经存在的备份对象
drop table if exists ray_lkp_model_bond_type;
commit;
drop table if exists ray_bond_rating_record;
commit;
drop table if exists ray_bond_rating_factor;
commit;
drop table if exists ray_rating_factor;
commit;
drop table if exists ray_bond_factor_option;
commit;
drop table if exists ray_bond_pledge;
commit;
drop table if exists ray_bond_rating_model;
commit;
drop table if exists ray_lkp_ratingcd_xw;
commit;
drop table if exists ray_bond_warrantor;
commit;

drop table if exists ray_lkp_finansubject_disp;
commit;

drop view if exists ray_vw_bond_rating_cacul;
commit;
drop view if exists ray_vw_bond_rating_cacul_pledge;
commit;
drop view if exists ray_vw_bond_rating_cacul_warrantor;
commit;

drop index if exists ray_pk_bond_pledge;
commit;

drop index if exists ray_pk_bond_warrantor;
commit;

drop index if exists ray_pk_lkp_ratingcd_xw;
commit;

drop index if exists ray_pk_bond_rating_model;
commit;

drop index if exists ray_pk_bond_rating_record;
commit;

drop index if exists ray_pk_bond_rating_factor;
commit;

drop index if exists ray_rating_hist_factor_score_pk;
commit;

drop index if exists ray_pk_bond_factor_option;
commit;

drop sequence if exists ray_seq_lkp_finansubject_disp;
commit;
