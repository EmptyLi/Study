delete from compy_factor_finance where 1 = 1;
insert into compy_factor_finance select * from ray_compy_factor_finance;
commit;
