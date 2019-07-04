--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from compy_incomestate limit 1;
------------------------------------------------------------------------------------------------------------------
--检查5个指标是否已更改为定性(factor_category_cd为1)
select count(*) from factor
where factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008')
and factor_category_cd=1;
--应该返回5条
------------------------------------------------------------------------------------------------------------------
--检查企业定量指标表中是否已删除以上五个指标的数据
select count(*) from compy_factor_finance
where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008')
and isdel = 0;--应该返回0条
------------------------------------------------------------------------------------------------------------------
--无报错信息，表明字段增加成功
select model_id from bond_factor_option limit 1;
select factor_dt from rating_factor limit 1;
select model_id, updt_by from lkp_ratingcd_xw limit 1;
-- select * from lkp_finansubject_disp limit 1;
-- select * from factor limit 1;
select adisposal_income,other_miincome from compy_incomestate limit 1;
-- select * from compy_factor_finance limit 1;
select rpt_dt from bond_warrantor limit 1;
select adjust_rating_reason,effect_start_dt,effect_end_dt from bond_rating_record limit 1;
select is_active from bond_rating_model limit 1;
select orig_record_sid,factor_val_revised,option_num_revised,ratio_revised,adjustment_comment from bond_rating_factor limit 1;
select rpt_dt from bond_pledge limit 1;
select rulerating_flag,warning_flag from lkp_model_bond_type limit 1;
select updt_by from compy_bondissuer limit 1;

------------------------------------------------------------------------------------------------------------------
-- 检查视图
select count(*)
from information_schema.views
where table_schema = 'public' and table_name in ('vw_finance_subject',
                                                 'vw_expired_rating',
                                                 'vw_bond_rating_cacul_warrantor',
                                                 'vw_bond_rating_cacul_pledge',
                                                 'vw_bond_rating_cacul',
                                                 'vw_compy_creditrating_latest');

-- 期望值: 6
------------------------------------------------------------------------------------------------------------------
-- 检查序列
select start_value from information_schema.sequences
where sequence_schema = 'public'
and sequence_name = 'seq_lkp_finansubject_disp';
-- 期望值：1423
------------------------------------------------------------------------------------------------------------------
-- 检查约束
select
  table_name,
  column_name
from information_schema.constraint_column_usage
where table_schema = 'public' and constraint_name in ('pk_bond_factor_option',
                                                      'pk_bond_pledge',
                                                      'pk_bond_rating_factor',
                                                      'pk_bond_rating_model',
                                                      'pk_bond_rating_record',
                                                      'pk_bond_warrantor',
                                                      'pk_compy_incomestate',
                                                      'pk_lkp_ratingcd_xw',
                                                      'rating_hist_factor_score_pkey');

------------------------------------------------------------------------------------------------------------------
-- 检查数据量,配套的业务表与备份表数据量的核对

-- 评级代码映射表
select count(*) from lkp_ratingcd_xw where model_id = 1 and constant_type <> 5;;
select count(*) from ray_lkp_ratingcd_xw where constant_type <> 5;

-- 利润表
select count(*) from compy_incomestate;
select count(*) from ray_compy_incomestate;

-- 债券担保人
select count(*) from bond_warrantor;
select count(*) from ray_bond_warrantor;

-- 债券评级模型表
select count(*) from bond_rating_model;
select count(*) from ray_bond_rating_model;

-- 债券抵质押品
select count(*) from bond_pledge;
select count(*) from ray_bond_pledge;

-- 债券评级记录表
select count(*) from bond_rating_record;
select count(*) from ray_bond_rating_record;

-- 债券评级指标表
select count(*) from bond_rating_factor;
select count(*) from ray_bond_rating_factor;

-- 债券指标档位表
select count(*) from bond_factor_option;
select count(*) from ray_bond_factor_option;

-- 评级指标值表
select count(*) from rating_factor;
select count(*) from ray_rating_factor;

-- 用户行为日志表
select count(*) from USER_ACTIVITY;
select count(*) from ray_USER_ACTIVITY;

-- 债券发行人信息
select count(*) from compy_bondissuer;
select count(*) from ray_compy_bondissuer;
------------------------------------------------------------------------------------------------------------------
select count(*) from factor
where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008')
and factor_category_cd = 1;
-- 期望值：5
------------------------------------------------------------------------------------------------------------------
select count(*) from compy_factor_finance where  factor_cd in
 ('factor_019','factor_021','factor_052','factor_005','factor_008')
 and isdel = 0;
-- 期望值：0
------------------------------------------------------------------------------------------------------------------
select count(*) from bond_rating_model where is_active = 1 and isdel = 0 and model_nm = 'LGD专家模型';
-- 期望值：1
------------------------------------------------------------------------------------------------------------------
select count(*) from lkp_ratingcd_xw where model_id =1 and constant_type = 5;
-- 期望值：18
------------------------------------------------------------------------------------------------------------------
select count(*) from lkp_model_bond_type;
-- 期望值：41
------------------------------------------------------------------------------------------------------------------
select count(*) from LKP_FINANSUBJECT_DISP;
-- 期望值：1422
------------------------------------------------------------------------------------------------------------------
select count(*) from  element
where element_cd in ('element_0097','element_0101','element_0115','element_0153','element_0180','element_0216')
   and data_type=1
   and unit is null
   and format is null;
-- 期望值：6

-----------------------------------------------------------------------------------------------------------------
select count(*) from lkp_model_bond_type where bond_type in('可转换债券','可分离交易可转债','可交换债券','项目收益债券',
'信贷资产证券化','住房抵押贷款证券化','汽车抵押贷款证券化','券商专项资产管理','资产支持票据','不动产投资信托(REITs)','未知')
and bond_type_flag = 0;
-- 期望值： 11

-----------------------------------------------------------------------------------------------------------------
select count(*) from lkp_model_bond_type where bond_type  not in('可转换债券','可分离交易可转债','可交换债券','项目收益债券',
'信贷资产证券化','住房抵押贷款证券化','汽车抵押贷款证券化','券商专项资产管理','资产支持票据','不动产投资信托(REITs)','未知')
and bond_type_flag = 1 and  issue_type = 1;
-- 期望值： 30
