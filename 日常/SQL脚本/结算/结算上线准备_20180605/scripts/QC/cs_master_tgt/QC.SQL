--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from compy_incomestate limit 1;

--检查5个指标是否已更改为定性(factor_category_cd为1)
select count(*) from factor where factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008') and factor_category_cd=1;--应该返回6条

--检查企业定量指标表中是否已删除以上五个指标的数据
select count(*) from compy_factor_finance where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');--应该返回0条

--无报错信息，表明字段增加成功
select * from bond_factor_option limit 1;
select * from rating_factor limit 1;
select * from lkp_ratingcd_xw limit 1;
select * from lkp_finansubject_disp limit 1;
select * from factor limit 1;
select * from compy_incomestate limit 1;
select * from compy_factor_finance limit 1;
select rpt_dt from bond_warrantor limit 1;
select * from bond_rating_record limit 1;
select * from bond_rating_model limit 1;
select * from bond_rating_factor limit 1;
select rpt_dt from bond_pledge limit 1;


-- 检查视图
select table_name
from information_schema.views
where table_schema = 'public' and table_name in ('vw_finance_subject',
                                                 'vw_expired_rating',
                                                 'vw_bond_rating_cacul_warrantor',
                                                 'vw_bond_rating_cacul_pledge',
                                                 'vw_bond_rating_cacul');
												 
-- 期望值											 
-- vw_finance_subject
-- vw_expired_rating
-- vw_bond_rating_cacul_warrantor
-- vw_bond_rating_cacul_pledge
-- vw_bond_rating_cacul


-- 检查序列
select start_value from information_schema.sequences
where sequence_schema = 'public'
and sequence_name = 'seq_lkp_finansubject_disp';

-- 期望值：1423

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
-- 检查数据量
select count(*) from lkp_ratingcd_xw where model_id = 1 and constant_type <> 5;;
select count(*) from ray_lkp_ratingcd_xw where constant_type <> 5;

select count(*) from compy_incomestate;
select count(*) from ray_compy_incomestate;

select count(*) from bond_warrantor;
select count(*) from ray_bond_warrantor;


select count(*) from bond_rating_model;
select count(*) from ray_bond_rating_model;


select count(*) from bond_pledge;
select count(*) from ray_bond_pledge;

select count(*) from bond_rating_record;
select count(*) from ray_bond_rating_record;


select count(*) from bond_rating_factor;
select count(*) from ray_bond_rating_factor;


select count(*) from bond_factor_option;
select count(*) from ray_bond_factor_option;
------------------------------------------------------------------------------------------------------------------

select bond_type_flag from lkp_model_bond_type
where type_id in (2898, 2853, 2842, 3146, 3145, 3073, 2901,
   3147, 2900, 3386, 3148, 2854, 3206, 2899, 060006);

-- 期望值: 0

select factor_category_cd from factor
where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');

-- 期望值：1

select * from compy_factor_finance where  factor_cd in
 ('factor_019','factor_021','factor_052','factor_005','factor_008');
 
-- 期望值：null

select model_nm from bond_rating_model;
-- LGD专家模型

select count(*) from lkp_ratingcd_xw where model_id =1 and constant_type = 5;
-- 期望值：18

select count(*) from lkp_model_bond_type;
-- 期望值：41

select count(*) from LKP_FINANSUBJECT_DISP;
-- 期望值：1422
