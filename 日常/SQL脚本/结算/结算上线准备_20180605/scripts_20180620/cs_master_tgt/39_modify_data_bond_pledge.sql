set time zone 'PRC';
update bond_pledge
    set isdel = 1
where secinner_id in (17137069
,17646356
,17652039
,17747655) and isdel = 0;
commit;
