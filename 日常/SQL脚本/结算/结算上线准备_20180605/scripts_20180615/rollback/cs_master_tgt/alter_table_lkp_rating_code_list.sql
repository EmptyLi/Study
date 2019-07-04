delete from lkp_rating_code_list where 1 = 1;
insert into lkp_rating_code_list
select * from ray_lkp_rating_code_list;
commit;
