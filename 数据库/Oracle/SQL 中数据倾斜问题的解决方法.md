### SQL 中数据倾斜问题的解决方法

#### 准备数据

step 1、创建测试表

```sql
create table tb_test as select * from dba_objects;
```



step 2、创建索引

```plsql
create index idx_tb_test on tb_test(object_id);
```



step 3、构造数据情况

```plsql
update tb_test set object_id = 10 where object_id > 10;
commit;
```



step 4、查看数据分布情况

```plsql
select object_id, count(*)
  from tb_test
 group by object_id ;
```



| object_id | count_num |
| --------- | --------- |
| 2         | 1         |
| 3         | 1         |
| 4         | 1         |
| 5         | 1         |
| 6         | 1         |
| 7         | 1         |
| 8         | 1         |
| 9         | 1         |
| 10        | 72558     |

#### 未使用绑定变量

​	未使用绑定变量的情况下通常数据分配不均匀不会造成问题，但这主要依赖于三个方面：

​	1、数据分布不均匀的字典是否作为过滤条件或连接条件

​	2、数据分布不均匀的字典是否有收集直方图，如果没有收集直方图就可能会有问题。在没有收集直方图的情况下，这个字段的过滤性 DENSITY 都是等于 1/NUM_DISTINCT；在收集了直方图的情况下，这个字段的规律性会根据条件值在直方图中的分布比例来计算。

​	3、数据库CURSOR_SHARING参数的值是否为EXACT，如果参数的值为FORCE，相当于使用绑定变量。那就会存在类似使用变量时存在的问题。



#### 不收集直方图的情况

step 1、不收集直方图

```plsql
begin
  dbms_stats.gather_table_stats('SCOTT',
  'TB_TEST',
  method_opt => 'FOR COLUMNS OBJECT_ID SIZE 1',
  cascade => TRUE);
END;
```



step 2、查看手机直方图的情况

```plsql
select table_name, column_name, histogram
  from dba_tab_col_statistics
 where table_name = 'TB_TEST'
   and column_name = 'OBJECT_ID';
```

| table_name | column_name | histogram |
| ---------- | ----------- | --------- |
| TB_TEST    | OBJECT_ID   | NONE      |

step 3、执行数据量比较少的代码

```plsql
select * from tb_test where object_id = 1;
```



step 4、执行数据量比较多的代码

```plsql
select * from tb_test where object_id = 10;
```



step 5、查看SQL缓存

```plsql
select sql_text, sql_id, plan_hash_value
  from v$sql
 where sql_text like 'select * from tb_test where object_id = %'
```



| sql_text                                 | sql_id        | plan_hash_value |
| ---------------------------------------- | ------------- | --------------- |
| select * from tb_test where object_id = 1 | 5q4pvwcqfs8kw | 3578346379      |
| select * from tb_test where object_id = 10 | 40k10twu11zfb | 3578346379      |

-   注意

>   plan_hash_value 相同代表使用了相同的执行计划



step 6、查看执行计划

```plsql
select sql_id,
       plan_hash_value,
       operation,
       object_name,
       cardinality,
       bytes,
       cost,
       time
  from v$sql_plan
 where sql_id in ('5q4pvwcqfs8kw', '40k10twu11zfb')
 order by address, id
```



| sql_id        | plan_hash_value | operation        | object_name | cardinality | bytes  | cost | time |
| ------------- | --------------- | ---------------- | ----------- | ----------- | ------ | ---- | ---- |
| 40k10twu11zfb | 3578346379      | SELECT STATEMENT | NULL        | NULL        | NULL   | 143  | NULL |
| 40k10twu11zfb | 3578346379      | TABLE ACCESS     | TB_TEST     | 8063        | 765985 | 143  | 2    |
| 40k10twu11zfb | 3578346379      | INDEX            | IDX_TB_TEST | 8063        | NULL   | 28   | 1    |
| 5q4pvwcqfs8kw | 3578346379      | SELECT STATEMENT | NULL        | NULL        | NULL   | 126  | NULL |
| 5q4pvwcqfs8kw | 3578346379      | TABLE ACCESS     | TB_TEST     | 7055        | 670225 | 126  | 2    |
| 5q4pvwcqfs8kw | 3578346379      | INDEX            | IDX_TB_TEST | 7055        | NULL   | 25   | 1    |



#### 收集直方图

step 1、收集直方图的情况

```plsql
begin
  dbms_stats.gather_table_stats('SCOTT',
  'TB_TEST',
  method_opt => 'FOR COLUMNS OBJECT_ID SIZE AUTO',
  cascade => TRUE);
END;
```



step 2、查看收集直方图的结果

```plsql
select table_name, column_name, histogram
  from dba_tab_col_statistics
 where table_name = 'TB_TEST'
   and column_name = 'OBJECT_ID';
```

| table_name | column_name | histogram |
| ---------- | ----------- | --------- |
| TB_TEST    | OBJECT_ID   | FREQUENCY |

step 3、查看直方图统计情况

```plsql
select *
  from dba_tab_histograms
 where table_name = 'TB_TEST'
   and column_name = 'OBJECT_ID'
```

| owner | table_name | column_name | endpoint_number | endpoint_value | endpoint_actual_value |
| ----- | ---------- | ----------- | --------------- | -------------- | --------------------- |
| SCOTT | TB_TEST    | OBJECT_ID   | 5572            | 10             |                       |

step 4、执行数据量比较少的代码

```plsql
select * from tb_test where object_id = 1;
```



step 5、执行数据量比较多的代码

```plsql
select * from tb_test where object_id = 10;
```



step 6、查看SQL缓存

```plsql
select sql_text, sql_id, plan_hash_value
  from v$sql
 where sql_text like 'select * from tb_test where object_id = %'
```



| sql_text                                 | sql_id        | plan_hash_value | address          | hash_value |
| ---------------------------------------- | ------------- | --------------- | ---------------- | ---------- |
| select * from tb_test where object_id = 1 | 5q4pvwcqfs8kw | 3578346379      | 00007FFC878DD548 | 753672796  |
| select * from tb_test where object_id = 10 | 40k10twu11zfb | 3578346379      | 00007FFC878B42A0 | 873528779  |

-   没有进行游标失效，所以执行计划相同，在收集信息时与一个参数相关 NO_INVALIDATE = FALSE




step 7、手工清楚缓存，然后重新解析

```plsql
begin
  dbms_shared_pool.purge('00007FFC878DD548,753672796', 'C');
  dbms_shared_pool.purge('00007FFC878B42A0,873528779', 'C');
END;
```



step 8、重新收集直方图

```plsql
begin
  dbms_stats.gather_table_stats('SCOTT',
  'TB_TEST',
  method_opt => 'FOR COLUMNS OBJECT_ID SIZE AUTO',
  cascade => TRUE,
  no_invalidate => false);
END;


alter system flush shared_pool;
```

step 9、重新执行相关语句

```plsql
select * from tb_test where object_id = 1;
select * from tb_test where object_id = 10;
```



step 10、查看相关缓存

```plsql
select sql_text, sql_id, plan_hash_value, address, hash_value
  from v$sql
 where sql_text like 'select * from tb_test where object_id = %'
```

| sql_text                                 | sql_id        | plan_hash_value | address          | hash_value |
| ---------------------------------------- | ------------- | --------------- | ---------------- | ---------- |
| select * from tb_test where object_id = 1 | 5q4pvwcqfs8kw | 3578346379      | 00007FFC878DD548 | 753672796  |
| select * from tb_test where object_id = 10 | 40k10twu11zfb | 1092599453      | 00007FFC878B42A0 | 873528779  |



#### 使用绑定变量



-   执行数据量比较少的SQL

```plsql
declare
  v_sql varchar2(3000);
begin
  v_sql := 'select * from tb_test where object_id = :1';
  execute immediate v_sql using 1;
END;
```



-   执行数据库量比较多的SQL

```plsql
declare
  v_sql varchar2(3000);
begin
  v_sql := 'select * from tb_test where object_id = :1';
  execute immediate v_sql using 10;
END;
```



-   查看相关信息

```
select sql_text, sql_id, plan_hash_value, address, hash_value
  from v$sql
 where sql_text like 'select * from tb_test where object_id = :1%'
```

| sql_text                                 | sql_id        | plan_hash_value | address          | hash_value |
| ---------------------------------------- | ------------- | --------------- | ---------------- | ---------- |
| select * from tb_test where object_id = :1 | an1xun7jpk1yv | 3578346379      | 00007FFC925FF3B0 | 3814262747 |

>   虽然字段 OBJECT_ID 上有使用直方图，但因为使用了绑定变量，ORACLE只硬解析了一次。Oracle 9I 就开始引入的BIND PEEK 不能解决这个问题，因为BIND PEEK 只是发生在第一次硬解析。



#### 解决方法

##### 方法1： 通过在应用代码中判断

>   为了避免非绑定变量的解析问题，并且可以在逻辑上将倾斜的值区分出来，则可以在应用代码中根据值的不同让它走不同的执行计划

```plsql
if variable = 10 then
	execute 'select /*+full(tb_test)*/ * from tb_test where object_id = :1' 
	using variable;
else
	execute 'select /*+index(tb_test idx_tb_test)*/ * from tb_test where object_id = :1' 
	using variable;
end if;
```



##### 方法2： 通过 HINT: BIND AWARE

>   Oracle 11G 开始引入了ACS特性，Adaptive Cursor Sharing 自适应游标，它可以共享监视候选查询的执行统计信息，并使相同的查询能够生成和使用不同的绑定值集合的不同执行计划。自适应游标的主要依赖于 bind_sensitive 游标的绑定敏感性和 bind_aware游标的绑定感知性。大改的作用就是在数据库第一次执行一条SQL语句时，做一次硬解析，优化器发现使用绑定变量并在过滤条件上有直方图，它将存储游标的执行统计信息。在下次使用不同绑定值指定相同SQL进行软解析时，把执行统计信息和存储在游标中的执行统计信息进行比较，来决定是否产生新的执行计划。这些执行统计信息可以在 V$SQL_CS_*相关的视图查看



-   V$SQL_CS_HISTOGRAM: 在执行历史直方图上显式执行统计的分布
-   V$SQL_CS_SELECTIVITY: 在带绑定变量的过滤条件显式存储在游标中的选择性区域或范围
-   V$SQL_CS_STATISTICS: 包含数据库收集的执行信息，用来确定是否应该使用BIND_AWARE的游标共享



>   另外在 V$SQL 中增加了 IS_BIND_SENSITIVE 和 IS_BIND_AWARE 列，来标识一个游标是否为绑定敏感和是否感知游标共享。



>   默认自适应游标特性是开启的，默认参数为

-   _optim_peek_user_binds = TRUE
-   _optimizer_adaptive_cursor_sharing = TRUE
-   _optimizer_extended_cursor_sharing = UDO
-   _optimizer_extended_cursor_sharing_rel = SIMPLE



-   添加SQLPATCH

```plsql
DECLARE
  v_sql CLOB;
BEGIN
  -- 取出原SQL的文本
  SELECT sql_fulltext
  INTO v_sql
  FROM v$sql
  WHERE sql_id = 'an1xun7jpk1yv' AND rownum = 1;

  -- 增加HINT
  sys.dbms_sqldiag_internal.i_create_patch(sql_text => v_sql,
                                           hint_text => 'BIND_AWARE',
                                           name => 'sql_fgarcttxvq2a');
END;
```

-   删除SQLPATCH

```plsql
BEGIN
  sys.DBMS_SQLDIAG.DROP_SQL_PATCH('sql_fgarcttxvq2a');
END;
```

-   查看SQLPATCH

```plsql
select *
  from dba_sql_patches
 where name = 'sql_fgarcttxvq2a';
```

-   查看信息

```plsql
SELECT
  sql_text,
  sql_id,
  plan_hash_value,
  is_bind_sensitive,
  is_bind_aware,
  is_shareable,
  sql_patch,
  executions
FROM v$sql
WHERE sql_text LIKE 'select * from tb_test where object_id = :1%'
```

| sql_text                                 | sql_id        | plan_hash_value | is_bind_sensitive | is_bind_aware | sql_patch |
| ---------------------------------------- | ------------- | --------------- | ----------------- | ------------- | --------- |
| select *  from tb_test where object_id = :1 | an1xun7jpk1yv | 3578346379      | Y                 | Y             | Y         |
| select *  from tb_test where object_id = :1 | an1xun7jpk1yv | 1092599453      | Y                 | Y             | Y         |

-   查看变量

```plsql
SELECT
  name,
  value
FROM (
  SELECT
    nam.ksppinm  name,
    val.ksppstvl value,
    val.ksppstdf isdefault
  FROM sys.x$ksppi nam, sys.x$ksppcv val
  WHERE nam.inst_id = val.inst_id
        AND nam.indx = val.indx
)
WHERE name IN ('_optim_peek_user_binds',
               '_optimizer_adaptive_cursor_sharing',
               '_optimizer_extended_cursor_sharing',
               '_optimizer_extended_cursor_sharing_rel');
```



| name                                   | value  |
| -------------------------------------- | ------ |
| _optimizer_extended_cursor_sharing     | UDO    |
| _optimizer_extended_cursor_sharing_rel | SIMPLE |
| _optimizer_adaptive_cursor_sharing     | TRUE   |
| _optim_peek_user_binds                 | TRUE   |
|                                        |        |





>   _optim_peek_user_binds = TRUE
>
>   如果对应的值改为FALSE，那么将 dbms_sqldiag_internal.i_create_patch中的 hint_text的值改为
>
>   'OPT_PARAM(''_optim_peek_user_binds'' ''true'') BIND_AWARE' 即可



##### 方法3： SPM



##### 方法4：其他情况

 - 单字段分布不均匀，多字段分布均匀

>   select * from TB where a = :1 and b = :2;
>
>   字段A 和字段B都是数据分布不均匀的字典，但业务逻辑上，在同一行记录上，字段A或者字段B，会是一个过滤性强的。之前用户分别在字段A和字段B上建了两个索引，这样在绑定变量的情况下，就会出现这条SQL一致选择其中一个索引做索引范围扫描，当遇到倾斜的值时就会出现性能问题。最后通过字段A和字段B建复合索引解决该问题



-   NULL 分布问题

>   select * from TB where A IS NULL;
>
>   表TB中大部分记录中字段A的值都为非空，经常要查询字段A为空的记录。单独在字段A上建索引，由于此索引中不存NULL值，所以WHERE条件A IS NULL 无法走索引。可以通过建立(A,1)的复合索引将字段A的NULL值也存进去，使A IS NULL使用索引



-   != 分布问题

>   select * from TB where A != 1
>
>   表TB中大部分记录中字段A的值都为1，经常要查询字段 A != 1的记录，字段A为NOT NULL。单独在字段A 上创建索引，通常这样的SQL是会走全表扫描，如果强制走索引会走 INDEX FULL SCAN 效率也不高。对于这种情况，如果想提高SQL的性能，当字段A中 != 1的值种类固定且不多时，可以将 WHERE 条件 A != 1改写为 A IN (X, Y, Z) 的形式；当字段A中 != 1的值种类不固定，可以建函数索引 DECODE(A,1,NULL,'2')并将WHERE 条件 A != 1改写为 DECODE(A,1,NULL,'2') = '2'

































