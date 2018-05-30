update bond_basicinfo t
set t.isdel = 1,
  t.updt_dt = systimestamp
where t.isdel = 0
      and t.secinner_id in (
  select secinner_id
  from bond_basicinfo
  where isdel = 0
  intersect
  select secinner_id
  from security
  where isdel = 1
);

update bond_basicinfo t
set t.isdel = 1,
  t.updt_dt = systimestamp
where t.isdel = 0
      and t.secinner_id in (
  select secinner_id
  from bond_basicinfo
  where isdel = 0
  minus
  select secinner_id
  from security
);
