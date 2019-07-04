update bond_pledge
set isdel = 1,
updt_dt = systimestamp
where bond_pledge_sid = '105821';
commit;
