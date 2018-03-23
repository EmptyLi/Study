```bash
[root@localhost database]# grep MemTotal /proc/meminfo
MemTotal:        1001332 kB
[root@localhost database]# grep SwapTotal /proc/meminfo
SwapTotal:       2098172 kB
[root@localhost database]# uname -m
x86_64
[root@localhost database]# cat /proc/version
Linux version 3.10.0-327.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu Nov 19 22:10:57 UTC 2015
[root@localhost database]# cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core)
[root@localhost database]# uname -r
3.10.0-327.el7.x86_64
[root@localhost database]# df -h /tmp
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       118G   13G  105G  11% /
[root@localhost database]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       118G   13G  105G  11% /
devtmpfs        475M     0  475M   0% /dev
tmpfs           489M  164K  489M   1% /dev/shm
tmpfs           489M   20M  470M   4% /run
tmpfs           489M     0  489M   0% /sys/fs/cgroup
/dev/sda1       297M  144M  154M  49% /boot
tmpfs            98M   28K   98M   1% /run/user/1000
[root@localhost database]# rpm -qa unixODBC
unixODBC-2.3.1-11.el7.x86_64
[root@localhost database]# rpm -q binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc glibc-devel ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel libXext libXtst libX11 libXau libxcb libXi make sysstat
binutils-2.23.52.0.1-55.el7.x86_64
package compat-libcap1 is not installed
package compat-libstdc++-33 is not installed
gcc-4.8.5-4.el7.x86_64
package gcc-c++ is not installed
glibc-2.17-105.el7.x86_64
glibc-devel-2.17-105.el7.x86_64
package ksh is not installed
libaio-0.3.109-13.el7.x86_64
package libaio-devel is not installed
libgcc-4.8.5-4.el7.x86_64
libstdc++-4.8.5-4.el7.x86_64
package libstdc++-devel is not installed
libXext-1.3.3-3.el7.x86_64
libXtst-1.2.2-2.1.el7.x86_64
libX11-1.6.3-2.el7.x86_64
libXau-1.0.8-2.1.el7.x86_64
libxcb-1.11-4.el7.x86_64
libXi-1.7.4-2.el7.x86_64
make-3.82-21.el7.x86_64
sysstat-10.1.5-7.el7.x86_64


[root@localhost database]# groupadd oinstall
[root@localhost database]# groupadd dba
[root@localhost database]# useradd -g oinstall -G dba oracle
[root@localhost database]# passwd oracle
Changing password for user oracle.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
[root@localhost database]# mkdir -p /usr/oracle
[root@localhost database]# chown -R oracle:oinstall /usr/oracle
[root@localhost database]# chmod -R 775 /usr/oracle
[root@localhost database]# chown -R oracle:oinstall /opt/oracle/oracinstall
chown: cannot access ‘/opt/oracle/oracinstall’: No such file or directory
[root@localhost database]# chown -R oracle:oinstall /home/raylee/Downloads/
[root@localhost database]# chmod -R 755 /home/raylee/Downloads/


```
