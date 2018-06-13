-- drop index if exists ray_pk_bond_factor_option;
-- drop index if exists ray_pk_bond_rating_model;
-- drop index if exists ray_pk_lkp_ratingcd_xw;
-- drop index if exists ray_pk_user_activity;
-- drop index if exists ray_rating_hist_factor_score_pk;
-- drop index if exists ray_pk_bond_rating_factor;
-- drop index if exists ray_pk_bond_rating_record;
-- drop index if exists ray_pk_bond_pledge;
-- drop index if exists ray_pk_bond_warrantor;
-- drop index if exists ray_pk_compy_incomestate;

drop table if exists ray_bond_factor_option;
drop table if exists ray_bond_rating_model;
drop table if exists ray_lkp_ratingcd_xw;
drop table if exists ray_user_activity;
drop table if exists ray_rating_factor;
drop table if exists ray_bond_rating_factor;
drop table if exists ray_lkp_model_bond_type;
drop table if exists ray_bond_rating_record;
drop table if exists ray_bond_pledge;
drop table if exists ray_bond_warrantor;
drop table if exists ray_compy_incomestate;
drop table if exists ray_lkp_finansubject_disp;
drop table if exists ray_factor_fix;
drop table if exists ray_compy_factor_finance;
drop table if exists ray_element;

drop sequence if exists ray_seq_lkp_finansubject_disp;

drop view if exists ray_vw_bond_rating_cacul;
drop view if exists ray_vw_bond_rating_cacul_pledge;
drop view if exists ray_vw_bond_rating_cacul_warrantor;
drop view if exists ray_vw_finance_subject;
drop view if exists ray_vw_expired_rating;
drop materialized view if exists ray_vw_compy_finanalarm;

drop view if exists ray_vw_compy_creditrating_latest;
