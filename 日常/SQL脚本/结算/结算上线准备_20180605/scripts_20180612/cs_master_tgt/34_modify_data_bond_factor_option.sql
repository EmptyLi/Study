update bond_factor_option a
set option_type=(select distinct b.factor_nm from bond_factor b where a.factor_cd=b.factor_cd)
where a.factor_cd in
(
'CORP_NATURE',
'CREDIT_REGION',
'GUARANTEE_TYPE',
'INDUSTRY',
'PLEDGE_CONTROL',
'PLEDGE_DEPEND',
'PLEDGE_REGION'
);
commit;
