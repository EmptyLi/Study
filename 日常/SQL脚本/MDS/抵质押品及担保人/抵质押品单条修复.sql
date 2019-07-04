-- backup table data date:20180517
-- create table ray_bond_pledge_0517 as select * from bond_pledge;
-- create table ray_bond_warrantor_expert_0517 as select * from bond_warrantor_expert;

----------------------------------------------担保人
-- 17546058
select * from bond_warrantor_expert where secinner_id = '17546058' and bond_warrantor_sid = '112233';
update bond_warrantor_expert
    set isdel = 1, updt_dt = now()
where secinner_id = '17546058'
 and bond_warrantor_sid = '112233';

-- 17413034
-- select * from bond_warrantor_expert where secinner_id = '17413034' and bond_warrantor_sid = '185313';

-- 17755014
select * from bond_warrantor_expert where secinner_id in ('17492023', '17755014');
select * from bond_warrantor_expert where secinner_id = '17755014' and bond_warrantor_sid = '108586';
update bond_warrantor_expert
    set isdel = 1, updt_dt = now()
where secinner_id = '17755014'
 and bond_warrantor_sid = '108586';

-- 17333809   17655761
select * from bond_warrantor_expert where secinner_id in ('17333809', '17655761');
select * from bond_warrantor_expert where secinner_id = '17655761' and bond_warrantor_sid = '112232';
update bond_warrantor_expert
    set isdel = 1, updt_dt = now()
where secinner_id = '17655761'
 and bond_warrantor_sid = '112232';

-- 17416756   17453378
select * from bond_warrantor_expert where secinner_id in ('17416756', '17453378');
select * from bond_warrantor_expert where secinner_id = '17453378'  and bond_warrantor_sid = '108715';

update bond_warrantor_expert
    set isdel = 1, updt_dt = now()
where secinner_id = '17453378'
 and bond_warrantor_sid = '108715';


-- 17619477  17672027
select * from bond_warrantor_expert where secinner_id in ('17619477', '17672027');
select * from bond_warrantor_expert where secinner_id = '17619477'  and bond_warrantor_sid = '108949';

update bond_warrantor_expert
    set isdel = 1, updt_dt = now()
where secinner_id = '17619477'
 and bond_warrantor_sid = '108949';
commit;
