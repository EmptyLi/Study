## 同一开发环境下安装两个数据库，必须处理以下问题
- 配置文件安装路径不能相同
- 数据库目录不能相同
- 启动脚本不能同名
- 端口不能相同
- socket文件的生成路径不能相同

```bash
mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz

解压和迁移
tar -xvf mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.6.21-linux-glibc2.5-x86_64 /usr/local/mysql

关闭iptables
临时关闭：service iptables stop
永久关闭：chkconfig iptables off

关闭selinux
vi /etc/sysconfig/selinux
SELINUX=DISABLED

创建mysql用户
groupadd -g 27 mysql
useradd -u 27 -g mysql mysql
id mysql
uid=501(mysql) gid=501(mysql) groups=501(mysql)

创建相关目录
mkdir -p /data/mysql/ {mysql_3306,mysql_3307}
mkdir /data/mysql/mysql_3306/ {data,log,tmp}
mkdir /data/mysql/mysql_3307/ {data,log,tmp}

更改目录权限
chown -R mysql:mysql /data/mysql/
chown -R mysql:mysql /usr/local/mysql/

复制my.cnf文件到etc目录
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

修改my.cnf（在一个文件中修改即可）
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld_multi]
mysqld = /usr/local/mysql /bin/mysqld_safe
mysqladmin = /usr/local/mysql /bin/mysqladmin
log = /data/mysql/mysqld_multi.log

[mysqld]
user=mysql
basedir = /usr/local/mysql
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqld3306]
mysqld=mysqld
mysqladmin=mysqladmin
datadir=/data/mysql/mysql_3306/data
port=3306
server_id=3306
socket=/tmp/mysql_3306.sock
log-output=file
slow_query_log = 1
long_query_time = 1
slow_query_log_file = /data/mysql/mysql_3306/log/slow.log
log-error = /data/mysql/mysql_3306/log/error.log
binlog_format = mixed
log-bin = /data/mysql/mysql_3306/log/mysql3306_bin

[mysqld3307]
mysqld=mysqld
mysqladmin=mysqladmin
datadir=/data/mysql/mysql_3307/data
port=3307
server_id=3307
socket=/tmp/mysql_3307.sock
log-output=file
slow_query_log = 1
long_query_time = 1
slow_query_log_file = /data/mysql/mysql_3307/log/slow.log
log-error = /data/mysql/mysql_3307/log/error.log
binlog_format = mixed
log-bin = /data/mysql/mysql_3307/log/mysql3307_bin

初始化3306数据库
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=/data/mysql/mysql_3306/data --defaults-file=/etc/my.cnf

初始化3307数据库
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=/data/mysql/mysql_3307/data --defaults-file=/etc/my.cnf

查看3306数据库
[root@mysql ~]# cd /data/mysql/mysql_3306/data
[root@mysql data]# ls

查看3307数据库
[root@mysql ~]# cd /data/mysql/mysql_3307/data
[root@mysql data]# ls

设置启动文件
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql

mysqld_multi进行多实例管理
启动全部实例：/usr/local/mysql/bin/mysqld_multi start
查看全部实例状态：/usr/local/mysql/bin/mysqld_multi report
启动单个实例：/usr/local/mysql/bin/mysqld_multi start 3306
停止单个实例：/usr/local/mysql/bin/mysqld_multi stop 3306
查看单个实例状态：/usr/local/mysql/bin/mysqld_multi report 3306

mysql的root用户初始密码是空，所以需要登录mysql进行修改密码，下面以3306为例：
mysql -S /tmp/mysql_3306.sock
set password for root@'localhost'=password('123456');
flush privileges;
```
