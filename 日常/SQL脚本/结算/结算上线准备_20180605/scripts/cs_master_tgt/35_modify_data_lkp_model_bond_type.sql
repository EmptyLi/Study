-- update lkp_model_bond_type  set
--    bond_type_flag = 0
-- where type_id in (2898, 2853, 2842, 3146, 3145, 3073, 2901, 3147, 2900, 3386, 3148, 2854, 3206, 2899, 060006);
-- commit;

update lkp_model_bond_type set rulerating_flag = 0, warning_flag =0;
update lkp_model_bond_type set bond_type_flag = 0 where bond_type in('可转换债券','可分离交易可转债','可交换债券','项目收益债券',
'信贷资产证券化','住房抵押贷款证券化','汽车抵押贷款证券化','券商专项资产管理','资产支持票据','不动产投资信托(REITs)','未知');
update lkp_model_bond_type set bond_type_flag = 1 ,issue_type = 1 where  bond_type not in('可转换债券','可分离交易可转债','可交换债券','项目收益债券',
'信贷资产证券化','住房抵押贷款证券化','汽车抵押贷款证券化','券商专项资产管理','资产支持票据','不动产投资信托(REITs)','未知');
commit;
