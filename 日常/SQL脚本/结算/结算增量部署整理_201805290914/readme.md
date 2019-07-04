## 结算增量部署脚本
> 准 备 人： 李睿
> 准备时间：2018-05-29
> 联系方式：lirui@chinacscs.com

### 部署脚本目录结构
```
.
├─cs_master_stg
├─cs_master_tgt
└─rollback
    ├─cs_master_stg
    └─cs_master_tgt
```
### 部署脚本清单及说明
编号  | 数据库  | 脚本名称  | 脚本类型  | 备注
--|---|---|---|--



### QC 检查脚本
#### cs_maste_stg
##### 1、对象个数检查
- 检查表
```sql
select table_name
from information_schema.tables
where table_schema = 'public' and table_name in ('stg_compy_incomestate',
                                                 'hist_compy_incomestate',
                                                 'stg_bond_warrantor',
                                                 'stg_bond_pledge',
                                                 'hist_bond_warrantor',
                                                 'hist_bond_pledge');
```

- 期望值

编号  | 表名
--|--
 1 |  stg_compy_incomestate
 2 |  hist_compy_incomestate
 3 |  stg_bond_warrantor
 4 |  stg_bond_pledge
 5 |  hist_bond_warrantor
 6 |  hist_bond_pledge

- 检查字段
```sql
--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from stg_compy_incomestate limit 1;
--无报错信息，表明字段增加成功
select adisposal_income,other_miincome from hist_compy_incomestate limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from stg_bond_warrantor limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from stg_bond_pledge limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from hist_bond_warrantor limit 1;
-- 无报错信息，表明字段增加成功
select rpt_dt from hist_bond_pledge limit 1;
```

- 期望值
> 无报错信息


##### 2、数据量检查
- 检查数据量
```sql
-- 检查数据量 hist_bond_pledge
select count(*) from hist_bond_pledge;
select count(*) from ray_hist_bond_pledge;
-- 检查数据量 hist_bond_warrantor
select count(*) from hist_bond_warrantor;
select count(*) from ray_hist_bond_warrantor;
-- 检查数据量 stg_bond_pledge
select count(*) from stg_bond_pledge;
select count(*) from ray_stg_bond_pledge;
-- 检查数据量 stg_bond_warrantor
select count(*) from stg_bond_warrantor;
select count(*) from ray_stg_bond_warrantor;

```
- 期望值
> 数据表与备份表数据量一致


##### 3、修改对象检查
```sql
```

#### cs_maste_tgt
##### 1、对象个数检查
- 检查表
```sql
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
```
- 期望值
> 无报错信息

- 检查视图
```sql
select table_name
from information_schema.views
where table_schema = 'public' and table_name in ('vw_finance_subject',
                                                 'vw_expired_rating',
                                                 'vw_bond_rating_cacul_warrantor',
                                                 'vw_bond_rating_cacul_pledge',
                                                 'vw_bond_rating_cacul');
```
- 期望值

编号  | 表名
--|--
 1 |  vw_finance_subject
 2 |  vw_expired_rating
 3 |  vw_bond_rating_cacul_warrantor
 4 |  vw_bond_rating_cacul_pledge
 5 |  vw_bond_rating_cacul


- 检查物化视图
```sql
```
- 期望值


- 检查序列
```sql
select start_value from information_schema.sequences
where sequence_schema = 'public'
and sequence_name = 'seq_lkp_finansubject_disp';
```
- 期望值
> 1423


- 检查约束
```sql
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
```
- 期望值

编号  |表名   |字段名
--|---|--
 1 |  bond_rating_record |  bond_rating_record_sid
 2 | bond_rating_model  |  model_id
 3 | bond_rating_factor  |  bond_rating_factor_sid
 4 | bond_pledge  |  bond_pledge_sid
 5 |  bond_factor_option |  bond_factor_option_sid
 6 | bond_warrantor  |  bond_warrantor_sid
 7 | compy_incomestate  | compy_incomestate_sid
 8 |  lkp_ratingcd_xw |  model_id
 9 | lkp_ratingcd_xw  |  constant_nm
 10 | lkp_ratingcd_xw  | ratingcd_nm
 11 |  lkp_ratingcd_xw | constant_type
 12 | rating_factor  | rating_factor_id


##### 2、数据量检查
- 检查数据量
```sql
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

```
- 期望值
> 数据表与备份表数据量一致

##### 3、修改对象检查
```sql
select bond_type_flag from lkp_model_bond_type
where type_id in (2898, 2853, 2842, 3146, 3145, 3073, 2901,
   3147, 2900, 3386, 3148, 2854, 3206, 2899, 060006);
```
- 期望值
> 0


```sql
select factor_category_cd from factor
where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');
```

- 期望值
> 1

```sql
select * from compy_factor_finance where  factor_cd in
 ('factor_019','factor_021','factor_052','factor_005','factor_008');
```

- 期望值
> 空

```sql
select model_nm from bond_rating_model;
```

- 期望值
> LGD专家模型

```sql
select count(*) from lkp_ratingcd_xw where model_id =1 and constant_type = 5;
```
>18

```sql
select count(*) from lkp_model_bond_type;
```
> 41

```sql
select count(*) from LKP_FINANSUBJECT_DISP;
```
>1422

### Q&A
