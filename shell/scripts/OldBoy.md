

- 【shell高级编程第四部分】19-linux系统的信号处理讲解

```bash
查看信号量
[raylee@localhost Desktop]$ stty -a

忽略 ctrl + c
trap "" 2

取消忽略 ctrl + c
trap ":" 2

捕获 ctrl + c 打印相关信息
[raylee@localhost 20180317]$ trap "echo -n 'Ur Enter Ctrl + C'" 2
[raylee@localhost 20180317]$ ^CUr Enter Ctrl + C

触发信号后清理文件
trap "find /tmp -type f -name "oldboy_*" -mmin + 1 | xargs rm -f && exit" INT
while true
do
   touch /tmp/oldboy_$(date +%F-%H-%H-%M-%S)
   usleep 5000
done

```

- 【shell高级编程第四部分】20-利用shell编程开发生产环境跳板机应用多种案例精讲

> method 1
> 1) 首先做好 ssh key 验证
> 2) 实现传统的远程连接菜单选择脚本
> 3) 利用 linux 信号防止用户在跳板机上操作
> 4) 用户登录后调用脚本

```bash
function trapper {
   trap ":" INT EXIT TSTP TERM HUP
}
while true
do
   trapper
   clear
   cat <<menu
   1) web a
   2) web b
   3) exit
menu
   read -p "Please Select : " num
   case "$num" in
      1)
      echo 1
      ssh 10.0.0.19
      ;;
      2)
      echo 2
      ssh 10.0.0.18
      ;;
      3|*)
      exit
      ;;
   esac
done
```

> method 2
> root 连接服务器， expect 每次重新建立 ssh key。

```bash

```


- 【shell高级编程第四部分】21-shell脚本开发习惯-规范-制度深度介绍

```bash
启动mysql
systemctl start mariadb.service 或者 systemctl start mysqld.service

结束
systemctl stop mariadb.service 或者 systemctl stop mysqld.service

重启
systemctl restart mariadb.service 或者 systemctl restart mysqld.service

开机自启
systemctl enable mariadb.service 或者 systemctl enable mysqld.service
```

- 登录的用户执行脚本

```bash
/etc/profile.d/
```


- mysql 在线安装 https://www.linuxidc.com/Linux/2016-09/135288.htm
```bash
1、配置YUM源
在MySQL官网中下载YUM源rpm安装包：http://dev.mysql.com/downloads/repo/yum/

# 下载mysql源安装包
shell> wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
# 安装mysql源
shell> yum localinstall mysql57-community-release-el7-8.noarch.rpm
检查mysql源是否安装成功

shell> yum repolist enabled | grep "mysql.*-community.*"

可以修改vim /etc/yum.repos.d/mysql-community.repo源，改变默认安装的mysql版本。比如要安装5.6版本，将5.7源的enabled=1改成enabled=0。然后再将5.6源的enabled=0改成enabled=1即可

2、安装MySQL

shell> yum install mysql-community-server
3、启动MySQL服务

shell> systemctl start mysqld
查看MySQL的启动状态

shell> systemctl status mysqld

4、开机启动

shell> systemctl enable mysqld
shell> systemctl daemon-reload
5、修改root本地登录密码

mysql安装完成之后，在/var/log/mysqld.log文件中给root生成了一个默认密码。通过下面的方式找到root默认密码，然后登录mysql进行修改：

shell> grep 'temporary password' /var/log/mysqld.log

shell> mysql -uroot -p
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';
或者

mysql> set password for 'root'@'localhost'=password('MyNewPass4!');
注意：mysql5.7默认安装了密码安全检查插件（validate_password），默认密码检查策略要求密码必须包含：大小写字母、数字和特殊符号，并且长度不能少于8位。

通过msyql环境变量可以查看密码策略的相关信息：

mysql> show variables like '%password%';

validate_password_policy：密码策略，默认为MEDIUM策略
validate_password_dictionary_file：密码策略文件，策略为STRONG才需要
validate_password_length：密码最少长度
validate_password_mixed_case_count：大小写字符长度，至少1个
validate_password_number_count ：数字至少1个
validate_password_special_char_count：特殊字符至少1个
上述参数是默认策略MEDIUM的密码检查规则。

修改密码策略

在/etc/my.cnf文件添加validate_password_policy配置，指定密码策略

# 选择0（LOW），1（MEDIUM），2（STRONG）其中一种，选择2需要提供密码字典文件
validate_password_policy=0
如果不需要密码策略，添加my.cnf文件中添加如下配置禁用即可：

validate_password = off
重新启动mysql服务使配置生效：

systemctl restart mysqld
6、添加远程登录用户

默认只允许root帐户在本地登录，如果要在其它机器上连接mysql，必须修改root允许远程连接，或者添加一个允许远程连接的帐户，为了安全起见，我添加一个新的帐户：

mysql> GRANT ALL PRIVILEGES ON *.* TO 'yangxin'@'%' IDENTIFIED BY 'Yangxin0917!' WITH GRANT OPTION;
7、配置默认编码为utf8

修改/etc/my.cnf配置文件，在[mysqld]下添加编码配置，如下所示：

[mysqld]
character_set_server=utf8
init_connect='SET NAMES utf8'

默认配置文件路径：
配置文件：/etc/my.cnf
日志文件：/var/log/  /var/log/mysqld.log
服务启动脚本：/usr/lib/systemd/system/mysqld.service
socket文件：/var/run/mysqld/mysqld.pid
```




- PostgreSQL 在线安装 https://www.cnblogs.com/stulzq/p/7766409.html
```bash
1.安装存储库
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-1.noarch.rpm

2.安装客户端
yum install postgresql10

3.安装服务端
yum install postgresql10-server

4.验证是否安装成功
rpm -aq| grep postgres

4.初始化数据库
/usr/pgsql-10/bin/postgresql-10-setup initdb

5.启用开机自启动
systemctl enable postgresql-10
systemctl start postgresql-10

6.配置防火墙
firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

7.修改用户密码
su - postgres  切换用户，执行后提示符会变为 '-bash-4.2$'
 psql -U postgres 登录数据库，执行后提示符变为 'postgres=#'
ALTER USER postgres WITH PASSWORD 'postgres'  设置postgres用户密码为postgres
\q  退出数据库

8.开启远程访问
vim /var/lib/pgsql/10/data/postgresql.conf
修改#listen_addresses = 'localhost'  为  listen_addresses='*'
当然，此处‘*’也可以改为任何你想开放的服务器IP

9.信任远程连接
vi m/var/lib/pgsql/10/data/pg_hba.conf
修改如下内容，信任指定服务器连接
# IPv4 local connections:
host    all            all      127.0.0.1/32      trust
host    all            all      192.168.157.1/32（需要连接的服务器IP）  trust

10.重启服务
systemctl restart postgresql-10
```

- CentOS7下mysql5.7忘记root密码的处理方法
```sql
1.vi /etc/my.cnf

2.在[mysqld]中添加
skip-grant-tables
例如：
[mysqld]
skip-grant-tables
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

3.重启mysql
service mysql restart

4.用户无密码登录
mysql -uroot -p (直接点击回车，密码为空)

5.选择数据库
use mysql;

6.修改root密码
update user set authentication_string=password('123456') where user='root';

7.执行
 flush privileges;

8.退出
exit;

9.删除
skip-grant-tables

10.重启mysql
service mysql restart
```
