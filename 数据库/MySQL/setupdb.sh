#!/bin/sh
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
if [ -d mysql-5.7.9-linux-glibc2.5-x86_64 ]; then
echo "mysql folder is exists"
else
tar -xzvf  mysql-5.7.9-linux-glibc2.5-x86_64.tar.gz
fi
ln -s  mysql-5.7.9-linux-glibc2.5-x86_64 mysql
cd mysql
echo "export PATH=/usr/local/mysql/bin:$PATH">>/etc/profile
source /etc/profile
service iptables stop
chkconfig iptables off
if [ -d mysql-files ]; then
echo "mysql-files is exists"
else
mkdir mysql-files
fi
chmod 770 mysql-files
chown -R mysql .
chgrp -R mysql .
if [ -d data ]; then
mv data data_$(date+%Y%m%d)
else
echo "data is not exist"
fi
./bin/mysqld --initialize --user=mysql

chown -R root .
chown -R mysql data mysql-files
./bin/mysqld_safe --user=mysql &

cp -rf support-files/mysql.server /etc/init.d/mysql.server
#./usr/local/mysql/support-files/mysql.server stop
ps -ef|grep mysql|grep -v grep |awk -F' ' '{print $2}'|xargs kill -s 9
       #serivce mysql stop
./bin/mysqld_safe --skip-grant-tables &
      #service mysql start
      #./usr/local/mysql/support-files/mysql.server start
mysql -uroot -p
use mysql;
update mysql.user set authentication_string=password('123456') where user='root';
flush privileges;
quit;

mysql -uroot -p123456
set password for 'root'@'localhost'=password("123456");
flush privileges;
