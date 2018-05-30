select *
from bond_warrantor_expert
where secinner_id in (
  select secinner_id
  from bond_warrantor_expert
  where warrantor_id is null)
  and isdel = 0
order by secinner_id;

select * from bond_warrantor_expert
  where bond_warrantor_sid in
      (	112699
,	109143
,	112702
,	112710
,	112693
,	112761
,	112701
,	112752
,	112709
,	112714
,	112713
,	112751
,	112692
,	109140
);


update bond_warrantor_expert
  set isdel = 1 ,
    updt_dt = now()
where bond_warrantor_sid in
      (	112699
,	109143
,	112702
,	112710
,	112693
,	112761
,	112701
,	112752
,	112709
,	112714
,	112713
,	112751
,	112692
,	109140
);
commit;

update bond_warrantor_expert
set warrantor_id = '313362', updt_dt = now()
where bond_warrantor_sid in (109157,109156);
commit;

-- select * from compy_basicinfo where company_nm = '江苏省信用再担保集团有限公司'
--                                                   江苏省信用再担保有限公司
