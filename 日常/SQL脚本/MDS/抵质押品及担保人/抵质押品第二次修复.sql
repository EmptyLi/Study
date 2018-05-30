select * from bond_pledge where bond_pledge_sid = '105209'

update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '105209'

105662

update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '105662';
--
-- 105429
-- 105428

update bond_pledge
    set pledge_nm = '面积为536.1万平方米的土地使用权', updt_dt = now()
where bond_pledge_sid = '105429';

update bond_pledge
    set pledge_nm = '面积为80万平方米的土地使用权', updt_dt = now()
where bond_pledge_sid = '105428';

-- 105408
update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '105408';

-- 106380
update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '106380';

-- 106388
update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '106388';


-- 106292
update bond_pledge
    set isdel = 1, updt_dt = now()
where bond_pledge_sid = '106292';

-- 106654
update bond_pledge
    set updt_dt = now(),
      pledge_value = 36.0800,
      pledge_nm = '国有土地使用权'
where bond_pledge_sid = '106654';

commit;
