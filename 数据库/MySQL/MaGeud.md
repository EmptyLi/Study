- 字符型
```sql
   char、binary：定长字符类型， char不区分大小写， binary 区分大小写
   varchar、varbinary：变长字符类型 varchar不区分大小写， varbinary 区分大小写 需要结束符[2个字符]
   text、tinytext、mediumtext、longtext：支持的字符不一致
   blob、tinybolb、mediumblob、longblob
   enum：1~65535 个字符串 很难拿来比较 存放的序数
   set：1~64 个字符的组合 很难拿来比较  存放的位数
```
- 数值型
```sql
精确数值型
   整型：tinyint、smallint、mediumint、int、bigint
   十进制型：decimal
近似数值型
   浮点型：real 是 float 还是 double 取决于 sql_mode
      单精度：float
      双精度：double
bit 位类型
```

- 日期时间
```sql
   date: 3个字节
   time: 3个字节
   datetime: 8个字节
   timestamp: 1970  相对时间计时法
   year(2)、year(4): 年份
```

- 字符类型修饰符
```sql
not null：非空约束
null
default 'string': 指明默认值
character set: 字符集
collaction: 排序规则
```
- auto_increment
```sql
1、必须是 int 类型
2、必须是整数，不可以使用无符号型整数
3、必须是主键或者唯一键
4、必须有非空约束 not null

last_insert_id() 返回最近生成的 auto_increment 值
mysql> select last_insert_id();
+------------------+
| last_insert_id() |
+------------------+
|                0 |
+------------------+
1 row in set (0.00 sec)
```
- 布尔型
```sql
mysql implements tinyint(1)
```

- 日期时间修饰符
```sql

```

- enum 和 set
```sql
mysql> create table enum_set(id int auto_increment not null, en enum('a','','1'), se set('a','1'), primary key (id));
Query OK, 0 rows affected (0.01 sec)

mysql> insert into enum_set(en, se) values('a', 'a');
Query OK, 1 row affected (0.01 sec)

mysql> insert into enum_set(en, se) values('a', 'b');
ERROR 1265 (01000): Data truncated for column 'se' at row 1
mysql> show errors;
+-------+------+-----------------------------------------+
| Level | Code | Message                                 |
+-------+------+-----------------------------------------+
| Error | 1265 | Data truncated for column 'se' at row 1 |
+-------+------+-----------------------------------------+
1 row in set (0.00 sec)

mysql> insert into enum_set(en, se) values('b', 'a');
ERROR 1265 (01000): Data truncated for column 'en' at row 1
mysql> show errors;
+-------+------+-----------------------------------------+
| Level | Code | Message                                 |
+-------+------+-----------------------------------------+
| Error | 1265 | Data truncated for column 'en' at row 1 |
+-------+------+-----------------------------------------+
1 row in set (0.00 sec)

mysql> select * from enum_set;
+----+------+------+
| id | en   | se   |
+----+------+------+
|  1 | a    | a    |
+----+------+------+
1 row in set (0.00 sec)
```

- sql_mode
```sql
定义了 mysqld 对约束的响应行为
全局，只是修改默认值，只对新创建的会话有效，对已经存在的会话无效
set global sql_mode = 'string';
set @@global.sql_mode = 'string';

mysql> show global variables like 'sql_mode';
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| Variable_name | Value                                                                                                                                     |
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| sql_mode      | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.01 sec)

TRADITIONAL: 传统模式，对所有非法的值都不允许传入
STRICT_TRANS_TABLES：对支持事务的表，所有非法的值都不允许传入
STRICT_ALL_TABLES: 对所有非法的值都不允许传入

会话
set session sql_mode = 'string';
set @@session.sql_mode = 'string';
```
- 数据库的DML
```sql
create, alter, drop
   {database|schema}
   [if exists]
   [if not exists]
```

- 存储引擎
```sql
存储引擎是表级别的概念，不是数据库级别的概念
mysql> show variables like '%default%engine%';
+----------------------------+--------+
| Variable_name              | Value  |
+----------------------------+--------+
| default_storage_engine     | InnoDB |
| default_tmp_storage_engine | InnoDB |
+----------------------------+--------+
2 rows in set (0.00 sec)
```

- 查看表结构
```sql
describe tablename;
```

- 查看表清单
```sql
show tables from {from | in} database_name;
```

- 查看表状态
```sql
show table status like 'string' where expr\G;

mysql> show table status like 'sys_config'\G;
*************************** 1. row ***************************
           Name: sys_config
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 6
 Avg_row_length: 2730
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: NULL
    Create_time: 2018-03-18 00:31:57
    Update_time: NULL
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options:
        Comment:
1 row in set (0.00 sec)

ERROR:
No query specified

Data_free
对表已经分配的空间，但是还没有使用，对于 myisam 存储引擎管用
```

===========================================================================================
