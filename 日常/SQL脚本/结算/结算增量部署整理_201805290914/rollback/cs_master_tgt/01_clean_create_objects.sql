-- 清理已经存在的备份对象
drop table if exists lkp_model_bond_type;
commit;
drop table if exists bond_rating_record;
commit;
drop table if exists bond_rating_factor;
commit;
drop table if exists rating_factor;
commit;
drop table if exists bond_factor_option;
commit;
drop table if exists bond_pledge;
commit;
drop table if exists bond_rating_model;
commit;
drop table if exists lkp_ratingcd_xw;
commit;
drop table if exists bond_warrantor;
commit;

drop table if exists lkp_finansubject_disp;
commit;

drop view if exists vw_bond_rating_cacul;
commit;
drop view if exists vw_bond_rating_cacul_pledge;
commit;
drop view if exists vw_bond_rating_cacul_warrantor;
commit;

drop index if exists pk_bond_pledge;
commit;

drop index if exists pk_bond_warrantor;
commit;

drop index if exists pk_lkp_ratingcd_xw;
commit;

drop index if exists pk_bond_rating_model;
commit;

drop index if exists pk_bond_rating_record;
commit;

drop index if exists pk_bond_rating_factor;
commit;

drop index if exists rating_hist_factor_score_pk;
commit;

drop index if exists pk_bond_factor_option;
commit;
