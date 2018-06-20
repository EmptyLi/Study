delete from lkp_subscribe_table where 1 = 1;
insert into lkp_subscribe_table
select * from ray_lkp_subscribe_table;
commit;
