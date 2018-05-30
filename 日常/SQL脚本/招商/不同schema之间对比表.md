## 表
```sql
select a.table_name, b.table_name, a.column_name, b.column_name,
       a.data_type, b.data_type, case when a.data_type <> b.data_type then 'F' else 'T' end as data_type_diff,
       a.data_length, b.data_length, case when a.data_length <> b.data_length then 'F' else 'T' end as data_length_diff,
       a.nullable , b.nullable, case when a.nullable <> b.nullable then 'F' else 'T' end as nullable_diff
 from user_tab_columns a
full join user_tab_columns@dblink_master_test b
  on a.table_name = b.table_name
  and a.column_name = b.column_name;
```
## 索引
```sql
select a.index_name, a.table_name, a.column_name,
       b.index_name, b.table_name, b.column_name
  from user_ind_columns a
  full join user_ind_columns b
    on a.table_name = b.table_name
   and a.column_name = b.column_name
where a.index_name not like 'BIN%'
  and a.index_name  like 'SYS%';
```

```sql
select a.index_name, a.table_name, a.column_name,
       b.index_name, b.table_name, b.column_name
  from user_ind_columns a
  full join user_ind_columns b
    on a.index_name = b.index_name
   and a.table_name = b.table_name
   and a.column_name = b.column_name
where a.index_name not like 'BIN%'
  and a.index_name not like 'SYS%';
```

## 对象
```sql
SELECT A.NAME,
       A.TYPE,
       A.LINE,
       B.NAME,
       B.TYPE,
       B.LINE,
       A.TEXT,
       B.TEXT,
       CASE
         WHEN TRIM(A.TEXT) <> TRIM(B.TEXT) THEN
          'F'
         ELSE
          'T'
       END TEXT_DIFF
  FROM USER_SOURCE A
  FULL JOIN USER_SOURCE@DBLINK_MASTER_TEST B
    ON A.NAME = B.NAME
   AND A.TYPE = B.TYPE
   AND A.LINE = B.LINE 
```
