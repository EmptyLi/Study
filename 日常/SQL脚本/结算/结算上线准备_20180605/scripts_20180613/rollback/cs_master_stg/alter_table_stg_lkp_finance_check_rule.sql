delete from stg_lkp_finance_check_rule where 1 =1 and check_cd='GIS01';
insert into stg_lkp_finance_check_rule
select * from ray_stg_lkp_finance_check_rule;
commit;