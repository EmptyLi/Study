drop table if exists ray_hist_bond_pledge;
commit;
drop table if exists ray_hist_bond_warrantor;
commit;
drop table if exists ray_stg_bond_pledge;
commit;
drop table if exists ray_stg_bond_warrantor;
commit;
drop table if exists ray_hist_compy_incomestate;
commit;
drop table if exists ray_stg_compy_incomestate;
commit;
drop table if exists ray_stg_lkp_finance_check_rule;
commit;
drop function if exists ray_fn_compy_finance_check();
commit;
drop table if exists ray_lkp_subscribe_table;
commit;
drop table if exists ray_subscribe_table;
commit;

--
drop table if exists ray_stg_compy_bondissuer;
commit;
drop table if exists ray_hist_compy_bondissuer;
commit;
