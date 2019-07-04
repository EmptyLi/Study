delete from factor where 1 = 1;
insert into factor select * from ray_factor_fix;
commit;