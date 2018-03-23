
- 串行隔离级
> 串行事务也是 Oracle 与非 Oracle 数据库最大的区别，也是 Oracle 非常大的优势。非Oracle 实现可重复读除了采用 select for update 进行锁定外，采用行共享查询锁。非 Oracle数据库采用的锁等待的方法，而不是抛错的方法，这样并发就会非常差，而且容易产生死锁。

> 非 Oracle 数据库，select就会锁，类似 select for update。而Oracle采用查询永远不锁，通过回滚段来得到事务级的一致性。Oracle的优势是有回滚段。

- 减轻 select for update 等待的时间
```sql
设置 select for update 的用户 resource profile 的 idel timeout 时间设置
```
```sql
设置 select for update nowait 或 select for update wait 180
最多等180秒。设置不等待，在发生堵塞时将自动抛错误
select for update 只要是查询出来的数据都会加锁，并不是只加了某一条，这个结果集的数据都会有锁
11G新特性: for update skip locked
```
```sql
select empno from scott.emp where job = 'CLERK';

declare
   l_rec scott.emp%rowtype;
   cursor c is select * from scott.emp where job = 'CLERK' for update skip locked;
begin
   open c;
   fetch c into l_rec;
   close c;
   dbms_output.put_line('I got empno = ' || l_rec.empno);
end;

-- I got empno = 7369

declare
   pragma autonomous_transaction;
   l_rec scott.emp%rowtype;
   cursor c is select * from scott.emp where job = 'CLERK' for update skip locked;
begin
   open c;
   fetch c into l_rec;
   close c;
   dbms_output.put_line('I got empno = ' || l_rec.empno);
   commit;
end;
```
- 悲观锁和乐观锁
```sql
悲观锁
select ... from tablename for update;

乐观锁
1、使用版本列的乐观锁定
create table dept(
   deptno    number(2),
   dname     varchar2(14),
   loc       varchar2(13),
   last_mod  timestamp with time zone default systimestamp not null,
   constraint dept_pk primary key(deptno)
);

每次更新数据判断 last_mod, 在更新之前判断 last_mod

2、使用ORA_ROWSCN的乐观锁定
可以获取某个块最后修改的SCN，设置可以查到基于行最后一次修改的SCN
```

- 不同数据库并发控制
> sybase 等都采用页(块)锁，而Oracle实现行锁，并发能力Oracle强很多。而其他数据库查询行会有共享锁来解决可重复读，丢失更新等问题，并发能力明显变差。
> Oracle锁不是稀缺资源，锁的状态只是标记在自身BUFFER或者块、段头中，不存在额外资源开销。而Oracle查询行永远不会锁，它通过回滚段来实现数据一致性
> 非Oracle数据库，如DB2，由于锁是放在内存的，每行记录一个72字节的锁，这样会大量消耗资源。当更新上百万行或者更新表的大部分行时，为了减少锁资源开销，自动将行/页扩大为表级锁。这样就会有些无辜的行被锁住了。
> 串行的隔离级使得使得被另一个用户查询表某区域的数据时不能向该表该区域插入数据，因为串行隔离级查询也是事务，它也有锁。

- SQL92标准支持了4种隔离级
|隔离等级|错读|非重复读取|幻象读|
|--|--|--|--|
|read uncommitted(未提交读取)|允许|允许|允许|
|read committed(提交读取)||允许|允许|
|repeatable read(重复读取)|||允许|
|serializable(串行化)||||

> 隔离级主要用于读，避免一些不准确的读
- 错读(未提交读)：读一个被另一事务未提交改变的数据值
```
未提交的数据可以被其他事务读取到
```

- 不可重复读(读失真)
```
前后两次读的数值不一致
```

- 幻象读
```
插入数据导致前后不一致
```

- Oracle读一致性分
```
1、语句级读一致性(不可重复读)
2、事务级一致性读

SCN
The value of an SCN is the logical point in time at which changes are made to a database
重启了Oracle这些记录都会记录在控制文件中
修改的记录一份是放在日志中，一份放到回滚段中
```
