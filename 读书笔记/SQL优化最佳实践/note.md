## 4.2 统计信息操作


### 4.2.2 对象统计信息
#### 1.收集统计信息
```sql
 -- 收集整个库中对象的统计信息
 exec dbms_stats.gather_database_stats(estimate_percent=>15);

 -- 收集指定schema的统计信息
 exec dbms_stats.gather_schema_stats(estimate_percent=>15);

 -- 收集指定表的统计信息
 exec dbms_stats.gather_table_stats(ownername=>'scott', tabname=>'employees', estimate_percent=>15);
```
> 通过 method_opt 指定是否收集直方图。

> 通过 granularity 指定如何处理分区对象的统计信息

> 通过 cascade 指定是否收集索引的统计信息

```sql
exec dbms_stats.gather_table_stats(ownname=>'prd_user',
                                   tabname=>'prd_syi_search',
                                   method_opt=>'for all indexed columns size repear',
                                   granularity=>'all',
                                   cascade=>true);
```
#### 2. 查看统计信息
对象  | 表/索引级别的统计 | 分区级别的统计 | 子分区级别的统计
--|---|---|--
表| user_tab_statistics | user_tab_statistics | user_tab_statistics
表| user_tables* | user_tab_partitions* | user_tab_subpartitions*
列| user_tab_col_statistics | user_part_col_statistics | user_subpart_col_statistics
列| user_tab_histograms | user_part_histograms | user_subpart_histograms
索引| user_ind_statistics | user_ind_statistics | user_ind_statistics
索引| user_indexes* | user_ind_partitions* | user_ind_subpartitions*

##### 查看表的统计信息
```sql
select table_name,
       num_rows,
       blocks,
       empty_blocks,
       avg_space,
       chain_cnt,
       avg_row_len,
       global_stats,
       user_stats,
       sample_size,
       to_char(t.last_analyzed, 'yyyy-mm-dd')
from dba_tables
where owner = 'xxx'
  and table_name = 'xxx';
```

- num_rows
> 数据的行数

- blocks
> 高水位下的数据块个数


- empty_blocks
> 高水位以上的数据块个数。dbms_stats不计算这个值，被设置为0

- avg_space
> 数据块中平均空余空间(字节)。dbms_stats不计算这个值，被设置为0

- chain_cnt
> 行链接和行迁移的数目。dbms_stats不计算这个值，被设置为0

- avg_row_len
> 行平均长度

- last_analyzed
> 最后收集统计信息时间

##### 查看索引的统计信息
```sql
select index_name,
       uniqueness,
       blevel,
       leaf_blocks,
       distinct_keys,
       num_rows,
       avg_leaf_blocks_per_key,
       avg_data_blocks_per_key,
       clustering_factor,
       global_stats,
       user_stats,
       sample_size,
       to_char(t.last_analyzed, 'yyyy-mm-dd')
from dba_indexes t
where table_owner = 'xxx'
  and table_name = 'xxx';
```

- num_rows
> 索引行

- leaf_blocks
> 索引也块数

- distinct_keys
> 索引不同的键数

- blevel
> 索引的blevel分支层数(btree的深度，从root节点到leaf节点的深度。如果root节点也是leaf节点，那么这个深度就是0)

- avg_leaf_blocks_per_key
> 每个键值的平均索引leaf块数(每个键值的平均索引leaf块数，如果是 unique index 或 pk，这个值总是1)

- clustering_factor
> 索引的群集因子(索引集群因子)

##### 查看列的统计信息
```sql
select column_name,
       num_distinct,
       density,
       num_buckets,
       num_nulls,
       global_stats,
       user_stats,
       histogram,
       sample_size,
       to_char(t.last_analyzed, 'yyyy-mm-dd')
from dba_tab_cols t
where owner = 'xx'
  and table_name = 'xx';
```

- num_distinct
> 不同值的数目

- num_nulls
> 字段值为null的数目

- density
> 选择率

- histogram
> 是否有直方图统计信息

直方图类型| 直方图名称
--|---
NONE | 没有
FREQUENCY | 频率类型
HEIGHT BALANCED | 平均分布类型

- num_buckets
> 直方图的桶数

#### 3. 修改统计信息
```sql
-- no_invalidate, 设置相关的SQL游标失效
exec dbms_stats.set_table_stats(ownname=>'HF',
                                tabname=>'EMP',
                                numrows=>1000000,
                                no_invalidate=>false);

exce dbms_stats.set_index_stats(ownname=>'HF',
                                indname=>'IDX_EMP',
                                numlblks=>1000000,
                                no_invalidate=>false);
```

#### 4. 删除统计信息
```sql
-- 删除表的统计信息
exec dbms_stats.delete_table_stats('scott', 'employees');

-- 删除索引的对象统计信息
exec dbms_stats.delete_index_stats('scott', 'employees_pk');

-- 删除列对象统计信息
exec dbms_stats.delete_column_stats(
   ownname => user,
   tabname => 'T',
   colname => 'VAL',
   col_stat_type => 'HISTOGRAM'
) ;
```

#### 5. 锁定统计信息
```sql
-- 锁定当前用户的所有对象
exec dbms_stats.lock_schema_stats(ownname=>user);

-- 锁定当前用户T表统计信息
exec dbms_stats.lock_table_stats(ownname=>user, tabname=>'T');

-- 解锁当前用户的对象统计信息
exec dbms_stats.unlock_schema_stats(ownname=>user);

-- 解锁当前用户的T表统计信息
exec dbms_stats.unlock_table_stats(ownname=>user, tabname=>'T')

-- 查看对象是否锁定了统计信息
select table_name
  from user_tab_col_statistics
 where stattype_locked is not null;
```

### 4.2.3 数据字典统计信息
#### 1. 收集统计信息
```sql
 -- 专门的方法进行收集
 exec dbms_stats.gather_dictionary_stats;

 -- 按照普通表采集
 exec dbms_stats.gather_table_stats(ownername=>'SYS', tabname=>'TAB$', estimate_percent=>100, cascade=>true);
```
#### 2. 删除统计信息
```sql
 exec dbms_stats.delete_dictionary_stats;

 exec dbms_stats.delete_table_stats(ownername=>'SYS', tabname=>'TAB$')
```

### 4.2.4 内部对象统计信息
> 内部对象的统计信息收集
```sql
 -- 收集内部对象的统计信息
 exec dbms_stats.gather_fixed_objects_stats();

 -- 收集某个内部对象的统计信息
 exec dbms_stats.gather_table_stats(ownername=>'SYS', tabname=>'X$KCCRSR', estimate_percent=>100, cascade=>true);

 -- 删除内部对象的统计信息
 exec dbms_stats.delete_fixed_objects_stats();

 -- 删除某个内部对象的统计信息
 exec dbms_stats.delete_table_stats(ownername=>'SYS', tabname=>'X$KCCRSR');
```
