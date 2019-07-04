delete from lkp_finansubject_disp where 1 = 1;
insert into lkp_finansubject_disp select * from ray_lkp_finansubject_disp;
commit;