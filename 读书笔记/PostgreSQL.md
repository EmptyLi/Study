- 查看数据库
``` sql
postgres=# \l
                                    List of databases
     Name      |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
---------------+----------+----------+-------------+-------------+-----------------------
 cs_master_stg | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0     | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
               |          |          |             |             | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
               |          |          |             |             | postgres=CTc/postgres
 test01        | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(5 rows)

```

- 查看数据目录
```bash
[root@localhost ~]# ls -l /var/lib/pgsql/10/data/
total 64
drwx------. 7 postgres postgres    62 Jun 14 11:23 base
-rw-------. 1 postgres postgres    30 Jun 19 09:01 current_logfiles
drwx------. 2 postgres postgres  4096 Jun 19 09:02 global
drwx------. 2 postgres postgres  4096 May 26 15:00 log
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_commit_ts
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_dynshmem
-rw-------. 1 postgres postgres  4269 Mar 18 15:43 pg_hba.conf
-rw-------. 1 postgres postgres  1636 Mar 18 15:43 pg_ident.conf
drwx------. 4 postgres postgres    65 Jun 15 18:47 pg_logical
drwx------. 4 postgres postgres    34 Mar 18 15:43 pg_multixact
drwx------. 2 postgres postgres    17 Jun 19 09:01 pg_notify
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_replslot
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_serial
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_snapshots
drwx------. 2 postgres postgres     6 Jun 19 09:01 pg_stat
drwx------. 2 postgres postgres    80 Jun 19 09:06 pg_stat_tmp
drwx------. 2 postgres postgres    17 Mar 18 15:43 pg_subtrans
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_tblspc
drwx------. 2 postgres postgres     6 Mar 18 15:43 pg_twophase
-rw-------. 1 postgres postgres     3 Mar 18 15:43 PG_VERSION
drwx------. 3 postgres postgres    58 Mar 18 15:43 pg_wal
drwx------. 2 postgres postgres    17 Mar 18 15:43 pg_xact
-rw-------. 1 postgres postgres    88 Mar 18 15:43 postgresql.auto.conf
-rw-------. 1 postgres postgres 22775 Mar 18 15:43 postgresql.conf
-rw-------. 1 postgres postgres    58 Jun 19 09:01 postmaster.opts
-rw-------. 1 postgres postgres   103 Jun 19 09:01 postmaster.pid
```

- 设置变量
```bash
export PATH=/usr/local/pgsql/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/pgsql/lib
```
> 所有用户生效，配置在/etc/profile
> 当前用户生效，配置在.bashrc 中

- 创建数据库簇
```bash
export PGDATA=/home/osdba/pgdata

# 创建数据库簇
initdb
```
- 数据库启停
```bash
-bash-4.2$ pg_ctl stop
waiting for server to shut down.... done
server stopped

-bash-4.2$ pg_ctl start
waiting for server to start....2018-06-18 18:27:15.521 PDT [10838] LOG:  listening on IPv6 address "::1", port 5432
2018-06-18 18:27:15.522 PDT [10838] LOG:  listening on IPv4 address "127.0.0.1", port 5432
2018-06-18 18:27:15.529 PDT [10838] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2018-06-18 18:27:15.533 PDT [10838] LOG:  listening on Unix socket "/tmp/.s.PGSQL.5432"
2018-06-18 18:27:15.544 PDT [10838] LOG:  redirecting log output to logging collector process
2018-06-18 18:27:15.544 PDT [10838] HINT:  Future log output will appear in directory "log".
 done
server started

```
> pg_ctl start -D $PGDATA

> PGDATA指向具体的PostgreSQL数据库的数据目录

> pg_ctl stop -D $PGDATA [-m SHUTDOWN-MODE]

1、 smart: 等所有的连接中止后，关闭数据库。如果客户端连接不终止，则无法关闭数据库
2、 fast：快速关闭数据库，断开客户端的连接，让已有的事务回滚，然后正常关闭数据库。相当于Oracle的immediate
3、 immediate： 立即关闭数据库，相当于数据库进程立即停止，直接退出，下次启动数据库需要进行恢复。相当于Oracle数据库关闭时的abort模式

- 配置 configure
```bash
# ./configure命令时指定较大的数据块，一般也需要指定较大的WAL日志块和WAL日志文件的大小
./configure --prefix=/usr/local/pgsql9.2.4 --with-perl --with-python --with-blocksize=128 --with-wal-blocksize=128 --with-wal-segsize=64
```

- 修改监听的IP和端口
```bash
# 数据目录下编辑 postgresql.conf
# - Connection Settings -

#listen_addresses = 'localhost'		# what IP address(es) to listen on;
					# comma-separated list of addresses;
					# defaults to 'localhost'; use '*' for all
					# (change requires restart)
#port = 5432				# (change requires restart)
```
> 修改完配置，需要重启数据库才能生效

- 与数据库log相关的参数
```bash
# - Where to Log -

log_destination = 'stderr'		# Valid values are combinations of
					# stderr, csvlog, syslog, and eventlog,
					# depending on platform.  csvlog
					# requires logging_collector to be on.

# This is used when logging to stderr:
logging_collector = on			# Enable capturing of stderr and csvlog
					# into log files. Required to be on for
					# csvlogs.
					# (change requires restart)

# These are only used if logging_collector is on:
log_directory = 'log'			# directory where log files are written,
					# can be absolute or relative to PGDATA
log_filename = 'postgresql-%a.log'	# log file name pattern,
					# can include strftime() escapes
#log_file_mode = 0600			# creation mode for log files,
					# begin with 0 to use octal notation
log_truncate_on_rotation = on		# If on, an existing log file with the
					# same name as the new log file will be
					# truncated rather than appended to.
					# But such truncation only occurs on
					# time-driven rotation, not on restarts
					# or size-driven rotation.  Default is
					# off, meaning append to existing files
					# in all cases.
log_rotation_age = 1d			# Automatic rotation of logfiles will
					# happen after that time.  0 disables.
log_rotation_size = 0			# Automatic rotation of logfiles will
					# happen after that much log output.
					# 0 disables.

```
>
