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
 1 | cs_master_stg  |  .\cs_master_stg\00_clean_backup_obj.sql  | SQL  | 清理之前存在的备份对象，以免发生冲突
 2 | cs_master_stg  |  .\cs_master_stg\01_backup_objs_and_datas.sql | SQL  | 备份即将修改的对象及其数据，用于回滚
 3 | cs_master_stg  |  .\cs_master_stg\02_create_table_hist_bond_pledge.sql | SQL  | 修改hist_bond_pledge表结构
 4 | cs_master_stg  |  .\cs_master_stg\03_create_table_hist_bond_warrantor.sql | SQL  |  修改hist_bond_warrantor表结构
 5 | cs_master_stg  |  .\cs_master_stg\04_create_table_stg_bond_pledge.sql | SQL  |  修改stg_bond_pledge表结构
 6 | cs_master_stg  |  .\cs_master_stg\05_create_table_stg_bond_warrantor.sql | SQL  |  修改stg_bond_warrantor表结构
 7 | cs_master_stg  |  .\cs_master_stg\06_recover_data.sql | SQL  |  将修改过后的表结构进行数据恢复
 8 | cs_master_stg  |  .\cs_master_stg\07_clean_backup_objects.sql | SQL  |  清理编号1备份的对象和数据
 9|cs_master_tgt|.\cs_master_tgt\00_clean_backup_obj.sql                                  | SQL | 清理之前存在的备份对象，以免发生冲突
 10|cs_master_tgt|.\cs_master_tgt\01_backup_objs_and_datas.sql                            | SQL | 备份即将修改的对象及其数据，用于回滚
 11|cs_master_tgt|.\cs_master_tgt\02_create_table_lkp_model_bond_type.sql                 | SQL | 创建表 lkp_model_bond_type
 12|cs_master_tgt|.\cs_master_tgt\03_create_table_bond_rating_record.sql                  | SQL | 修改表 bond_rating_record
 13|cs_master_tgt|.\cs_master_tgt\04_create_table_bond_rating_factor.sql                  | SQL | 修改表 bond_rating_factor
 14|cs_master_tgt|.\cs_master_tgt\05_create_table_rating_factor.sql                       | SQL | 修改表 rating_factor
 15|cs_master_tgt|.\cs_master_tgt\06_create_table_bond_factor_option.sql                  | SQL | 修改表 bond_factor_option
 16|cs_master_tgt|.\cs_master_tgt\07_create_table_bond_pledge.sql                         | SQL | 修改表 bond_pledge
 17|cs_master_tgt|.\cs_master_tgt\08_create_table_bond_rating_model.sql                   | SQL | 修改表 bond_rating_model
 18|cs_master_tgt|.\cs_master_tgt\09_create_table_lkp_ratingcd_xw.sql                     | SQL | 修改表 lkp_ratingcd_xw
 19|cs_master_tgt|.\cs_master_tgt\10_create_table_bond_warrantor.sql                      | SQL | 修改表 bond_warrantor
 20|cs_master_tgt|.\cs_master_tgt\11_create_view_vw_bond_rating_cacul.sql                 | SQL | 修改视图 vw_bond_rating_cacul
 21|cs_master_tgt|.\cs_master_tgt\12_create_view_vw_bond_rating_cacul_pledge.sql          | SQL | 创建视图 vw_bond_rating_cacul_pledge
 22|cs_master_tgt|.\cs_master_tgt\13_create_view_vw_bond_rating_cacul_warrantor.sql       | SQL | 创建视图 vw_bond_rating_cacul_warrantor
 23|cs_master_tgt|.\cs_master_tgt\14_init_data_lkp_model_bond_type.sql                    | SQL | 初始化数据 lkp_model_bond_type
 24|cs_master_tgt|.\cs_master_tgt\15_init_data_lkp_finansubject_disp.sql                  | SQL | 修改数据 lkp_finansubject_disp
 25|cs_master_tgt|.\cs_master_tgt\16_init_data_lkp_ratingcd_xw.sql                        | SQL | 修改数据 lkp_ratingcd_xw
 26|cs_master_tgt|.\cs_master_tgt\17_recover_data.sql                                     | SQL | 将修改过后的表结构进行数据恢复
 27|cs_master_tgt|.\cs_master_tgt\18_modify_data.sql                                      | SQL | 修复数据 lkp_model_bond_type
 28|cs_master_tgt|.\cs_master_tgt\19_modify_data_bond_pledge.sql                          | SQL | 修复数据 bond_pledge
 29|cs_master_tgt|.\cs_master_tgt\20_modify_data_bond_warrantor.sql                       | SQL | 修复数据 bond_warrantor
 30|cs_master_tgt|.\cs_master_tgt\21_clean_backup_objects.sql                             | SQL | 清理编号9备份的对象和数据
 31| cs_master_stg | .\rollback\cs_master_stg\01_clean_create_objects.sql | SQL | 清理掉已经创建的对象
 32| cs_master_stg | .\rollback\cs_master_stg\01_clean_create_objects.sql | SQL | 回滚原来的对象和数据
 33| cs_master_tgt | .\rollback\cs_master_tgt\01_clean_create_objects.sql | SQL | 清理掉已经创建的对象
 34| cs_master_tgt | .\rollback\cs_master_tgt\01_clean_create_objects.sql | SQL | 回滚原来的对象和数据
  |   |   |   |



### QC 检查脚本
#### 1、对象个数检查
```sql
select * from pg_tables;
```

#### 2、数据量检查
```sql
```
#### 3、修改对象检查
```
```
### Q&A
