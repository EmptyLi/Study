set time zone 'PRC';
update bond_warrantor
set isdel = 1
where warrantor_id is null
  and isdel = 0;
commit;
