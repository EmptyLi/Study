delete from subscribe_table where 1 = 1;
insert into subscribe_table
select * from ray_subscribe_table;
commit;
