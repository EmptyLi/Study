-- 20180530 1619
-- 经确认80031116 没有担保人的情况
update BOND_WARRANTOR_EXPERT
set isdel = 1,
  updt_dt = clock_timestamp()
where secinner_id = '17457627';
commit;
