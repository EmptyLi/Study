## 第7天【find命令、if语句、磁盘管理、文件系统管理】
### find命令详解(01)_recv
#### 文件查找
> 在文件系统上查找符合条件的文件
> 在文件查找： locate, find

##### locate
> 非实时查找(数据库查找)
> 依赖于事先构造的索引, 索引的构建是在系统较为空闲时自动进行，周期性任务实现， 如果要更新数据库(updatedb)
> 索引构建过程需要遍历整个根文件系统，极消耗资源
> 查找速度快，可以进行模糊查找
> 用法： locate KEYWORD

```bash
[root@localhost ~]# updatedb
```
##### find
> 实时查找
> 通过遍历指定路径下的文件系统完成文件查找
> 相比较locate查找速度略慢，精确查找，实时查找
> 用法： find [OPTION] ... [查找路径] [查找条件] [处理动作]
> 查找路径：指定具体目标路径，默认为当前目录
> 查找条件：指定的查找标准，可以文件名、大小、类型、权限等标准进行，默认为找出指定路径下的所有文件
> 根据文件名查找(区分大小写): -name "文件名称" ; 支持glob *, ?, [], [^]
> 根据文件名查找(忽略大小小)：-iname "文件名称"
> 根据正则表达式： -regexp "PATTERN"   ;以PATTERN匹配整个文件路径字符串，而不仅仅是文件名称
> 根据属主查找：-user USERNAME
> 根据属组查找：-group GROUPNAME
> 根据UID查找：-uid UserID
> 根据GID查找：-gid GroupID
> 查找没有属主的文件：-nouser
> 查找没有属组的文件：-nogroup
> 根据文件类型查找：-type TYPE ; f：普通文件 d：目录文件 l：符号链接文件 s:套接字文件 b：块设备文件 c:字符设备 p:管道文件
> 组合条件： -a 相当于 and； -o 相当于 or； ! 相当于 not
> 根据大小查找文件：-size [+|-]unit; unit: K M G； 如果不加符号的范围为 (unit-1, unit]; -unitK [0, unit-1]; +unitK (unit, ∞)
> 根据时间来查找(天)： -atime -mtime -ctime [+|-]unit
> 根据时间来查找(小时)：-amin -mmin -cmin [+|-]unit
> 根据权限查找：-perm [+|-] MODE; MODE 精确权限匹配；/MODE 任何一类(u,g,o)对象的权限中只要能有一位匹配即可； -MODE 每一类对象都必须同时拥有为其制定的权限标准。
> 处理动作：对符合条件的文件做什么操作，默认输出至屏幕
> -print 默认的处理动作，显式至屏幕
> -ls    类似于查找到的文件执行 "ls -l"命令
> -delete 删除查找到的文件
> -fls /path/to/somewhere 查找到素有文件的长格式信息保存至指定文件中
> -ok COMMAND {} 对查找到的每个文件执行由COMMAND指定的命令 {}:用于引用查找到的文件名称自身

```bash
# 在home目录下查找属主为 centos 的文件
find /home -user centos -ls

# 在home目录下查找属组为 centos 的文件
find /home -group centos -ls

实验 -nouser -nogroup
useradd gentoo
su gentoo
cd /tmp
cp /etc/issue ./
cp /etc/passwd ./
# 谁复制的权限归谁
[gentoo@localhost tmp]$ exit
exit
[root@localhost ~]# cd /tmp

[root@localhost tmp]# userdel gentoo

[root@localhost tmp]# find /tmp -nouser -ls
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd

# 查找文件系统中没有属主或者属组的文件
[root@localhost tmp]# find /tmp -nouser -ls
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd
[root@localhost tmp]# find /tmp -nogroup -ls
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd
[root@localhost tmp]# find /tmp -nouser -o -nogroup
/tmp/issue
/tmp/passwd
[root@localhost tmp]# find /tmp -nouser -o -nogroup -ls
[root@localhost tmp]# find /tmp \( -nouser -o -nogroup \) -ls
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd

# tmp目录下属主不是root的文件
[root@localhost tmp]# find /tmp ! -user root -ls
137525244    0 srwxrwxrwx   1 gdm      gdm             0 Mar 17 23:04 /tmp/.ICE-unix/3972
137470764    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.ICE-unix/9278
137470762    0 drwx------   2 raylee   raylee         23 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD
137470763    0 srw-------   1 raylee   raylee          0 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD/agent.9278
406220950    0 drwx------   2 raylee   raylee         19 Mar 17 23:04 /tmp/.esd-1000
406220951    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.esd-1000/socket
406221229    0 drwx------   2 raylee   raylee          6 Mar 17 23:21 /tmp/tracker-extract-files.1000
406220931    0 drwxr-xr-x   2 raylee   raylee          6 Mar 17 23:05 /tmp/hsperfdata_raylee
408475553    4 -rw-------   1 postgres postgres       50 Mar 18 01:43 /tmp/.s.PGSQL.5432.lock
408475554    0 srwxrwxrwx   1 postgres postgres        0 Mar 18 01:43 /tmp/.s.PGSQL.5432
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd

# /tmp目录下属主是 raylee 且文件不是 hsperfdata_raylee
[root@localhost tmp]# find /tmp -user raylee -a ! -name "hsperfdata_raylee" -ls
137470764    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.ICE-unix/9278
137470762    0 drwx------   2 raylee   raylee         23 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD
137470763    0 srw-------   1 raylee   raylee          0 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD/agent.9278
406220950    0 drwx------   2 raylee   raylee         19 Mar 17 23:04 /tmp/.esd-1000
406220951    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.esd-1000/socket
406221229    0 drwx------   2 raylee   raylee          6 Mar 17 23:21 /tmp/tracker-extract-files.1000

# 属主不是 root 并且名字不是 fstab
[root@localhost tmp]# find /tmp \( -not -user root -a -not -name "fstab" \) -ls
137525244    0 srwxrwxrwx   1 gdm      gdm             0 Mar 17 23:04 /tmp/.ICE-unix/3972
137470764    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.ICE-unix/9278
137470762    0 drwx------   2 raylee   raylee         23 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD
137470763    0 srw-------   1 raylee   raylee          0 Mar 17 23:04 /tmp/ssh-4wFvurVKCHbD/agent.9278
406220950    0 drwx------   2 raylee   raylee         19 Mar 17 23:04 /tmp/.esd-1000
406220951    0 srwxrwxrwx   1 raylee   raylee          0 Mar 17 23:04 /tmp/.esd-1000/socket
406221229    0 drwx------   2 raylee   raylee          6 Mar 17 23:21 /tmp/tracker-extract-files.1000
406220931    0 drwxr-xr-x   2 raylee   raylee          6 Mar 17 23:05 /tmp/hsperfdata_raylee
408475553    4 -rw-------   1 postgres postgres       50 Mar 18 01:43 /tmp/.s.PGSQL.5432.lock
408475554    0 srwxrwxrwx   1 postgres postgres        0 Mar 18 01:43 /tmp/.s.PGSQL.5432
408475559    4 -rw-r--r--   1 1001     1001           23 Mar 18 01:52 /tmp/issue
408475563    4 -rw-r--r--   1 1001     1001         2474 Mar 18 01:53 /tmp/passwd

# 查找文件大小不大于 3k的文件
[root@localhost var]# find /var -size 3k -exec ls -lh {} \;
-rw-r--r--. 1 root root 2.8K Mar 18 00:30 /var/lib/yum/history/2018-03-18/4/saved_tx
-rw-r--r--. 1 root root 2.4K Mar 17 23:02 /var/lib/authconfig/last/libuser.conf
-rw-r--r--. 1 root root 2.2K Mar 17 23:04 /var/lib/plymouth/boot-duration
-rw-r-----. 1 mysql mysql 2.5K Mar 18 00:31 /var/lib/mysql/sys/innodb_buffer_stats_by_schema.frm

```

### 特殊权限及if语句(02)_recv
```bash
1、查找 /var 目录下属主为root，且属组为mail的所有文件和目录
find /var -user root -a -group mail

2、查找 /usr 目录下不属于 root、bin或hadoop的所有文件或目录
find /usr -not -user root -a -not -user bin -a -not -user hadoop
find /usr -not \( -user root -o -user bin -o -user hadoop \)

3、查找 /etc 目录下最近一周内其文件修改过，同时属主不为root，也不是hadoop的文件或目录
find /etc -mtime -7 -a -not -user root -a -not -user hadoop

4、查找当前系统上没有属主或属组，且最近一周内曾被访问过的文件或目录
find / \(-nouser -o -nogroup \) -a -atime -7

5、查找 /etc 目录下大于1M类型为普通文件的所有文件或目录
find /etc -size +1M -a -type f

6、查找 /etc 目录下所有用户都没有写权限的文件
find /etc -not -perm +222

7、查找 /etc 目录至少有一类用户没有执行权限的文件
find /etc -not -perm -111

8、查找 /etc/init.d 目录下，所有用户都有执行权限，且其他用户有写权限的文件
find /etc/init.d -perm -113
```

#### 特殊权限
> SUID、SGID、Sticky
> (1) 权限 r, w, x
> (2) 安全上下文
> 脚本运行的权限取决于发起用户的权限
> 进程有属主和属组；文件有属主和属组
> cat 命令属主和属组都是root，如果以centos的用户来运行该命令，判断centos既不是属主也不是属组，所以以other身份来运行。进程的属主和属组都是centos， centos。任何一个可执行程序文件能不能启动为进程，取决于发起者对程序文件是否拥有执行全讯啊。启动为进程之后，其进程的属主为发起者；属组为发起者所属的组。进程访问文件时的权限取决于进程的发起者：(a)进程的发起者，同文件的属主；则应用文件属主权限(b)进程的发起者，属于文件的属组。(c)应用文件"其他"权限

##### SUID
> 文件发起者调用命令进程的属主不属于发起者，而是属于文件的属主

```bash
[root@localhost ~]# ls -l /etc/passwd
-rw-r--r--. 1 root root 2431 Mar 18 01:54 /etc/passwd
[root@localhost ~]# ls -l /etc/shadow
----------. 1 root root 1175 Mar 18 01:54 /etc/shadow
[root@localhost ~]# ls -l `which passwd`
-rwsr-xr-x. 1 root root 27832 Jun  9  2014 /bin/passwd

# SUID 提升权限
[root@localhost ~]# ls -l /bin/cat
-rwxr-xr-x. 1 root root 54048 Nov 19  2015 /bin/cat
[root@localhost ~]# cp /bin/cat /tmp/
[root@localhost ~]# ls -l /tmp/cat
-rwxr-xr-x. 1 root root 54048 Mar 18 17:57 /tmp/cat
[root@localhost ~]# useradd centos
[root@localhost ~]# su - centos
Welcome Connect UID: 1001
[centos@localhost ~]$ /tmp/cat /etc/shadow
/tmp/cat: /etc/shadow: Permission denied
[centos@localhost ~]$ exit
logout
[root@localhost ~]# chmod u+s /tmp/cat
[root@localhost ~]# ls -l /tmp/cat
-rwsr-xr-x. 1 root root 54048 Mar 18 17:57 /tmp/cat
[root@localhost ~]# su - centos
Last login: Sun Mar 18 17:57:52 PDT 2018 on pts/1
Welcome Connect UID: 1001
[centos@localhost ~]$ /tmp/cat /etc/shadow
root:$1$D$Op2GWu1aPsPCQ/lhk0nGJ1::0:99999:7:::
bin:*:16659:0:99999:7:::

```
##### SGID
> 创建文件时，一般文件的属组是创建者的基本组
> 一旦某目录被设定了SGID，则对此目录有写权限的用户在此目录中创建的文件所属的组为此目录的属组
> 如果有文件存放的目录有写权限，就可以删除该目录下的其他文件

```bash
[root@localhost ~]# groupadd mygrp
[root@localhost ~]# cd /tmp
[root@localhost tmp]# mkdir test
[root@localhost tmp]# ll -dh test
drwxr-xr-x. 2 root root 6 Mar 18 22:08 test
[root@localhost tmp]# chown :mygrp test
[root@localhost tmp]# ll -dh test
drwxr-xr-x. 2 root mygrp 6 Mar 18 22:08 test
[root@localhost tmp]# id centos
uid=1001(centos) gid=1001(centos) groups=1001(centos)
[root@localhost tmp]# usermod -a -G mygrp centos
[root@localhost tmp]# id centos
uid=1001(centos) gid=1001(centos) groups=1001(centos),1002(mygrp)
[root@localhost tmp]# useradd gentoo -G mygrp
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.
Creating mailbox file: File exists
[root@localhost tmp]# id gentoo
uid=1002(gentoo) gid=1003(gentoo) groups=1003(gentoo),1002(mygrp)
[root@localhost tmp]# ll -dh test
drwxr-xr-x. 2 root mygrp 6 Mar 18 22:08 test
[root@localhost tmp]# chmod g+w test
[root@localhost tmp]# ll -dh test
drwxrwxr-x. 2 root mygrp 6 Mar 18 22:08 test

[root@localhost tmp]# su - centos
Last login: Sun Mar 18 17:58:26 PDT 2018 on pts/1
Welcome Connect UID: 1001
[centos@localhost ~]$ cd /tmp/test
[centos@localhost test]$ touch a.centos
[centos@localhost test]$ ll -dh a.centos
-rw-rw-r--. 1 centos centos 0 Mar 18 22:15 a.centos
[centos@localhost test]$ exit
logout

[root@localhost tmp]# su - gentoo
Last login: Sun Mar 18 22:14:02 PDT 2018 on pts/1
su: warning: cannot change directory to /home/gentoo: Permission denied
Welcome Connect UID: 1002
-bash: /home/gentoo/.bash_profile: Permission denied
-bash-4.2$ cd /tmp/test
-bash-4.2$ touch a.gentoo
-bash-4.2$ ll -dh a.gentoo
-rw-rw-r--. 1 gentoo gentoo 0 Mar 18 22:17 a.gentoo
-bash-4.2$ exit
logout

[root@localhost tmp]# chmod g+s test/
[root@localhost tmp]# ls -ldh test/
drwxrwsr-x. 2 root mygrp 36 Mar 18 22:17 test/
[root@localhost tmp]# su - centos
Last login: Sun Mar 18 22:15:29 PDT 2018 on pts/1
Welcome Connect UID: 1001
[centos@localhost ~]$ cd /tmp/test
[centos@localhost test]$ touch aa.centos
[centos@localhost test]$ ls -ldh aa.centos
-rw-rw-r--. 1 centos mygrp 0 Mar 18 22:18 aa.centos

-bash-4.2$ id
uid=1002(gentoo) gid=1003(gentoo) groups=1003(gentoo),1002(mygrp) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
-bash-4.2$ cd /tmp/test
-bash-4.2$ ll
total 0
-rw-rw-r--. 1 centos mygrp  0 Mar 18 22:18 aa.centos
-rw-rw-r--. 1 centos centos 0 Mar 18 22:15 a.centos
-rw-rw-r--. 1 gentoo gentoo 0 Mar 18 22:17 a.gentoo
-bash-4.2$ rm a.centos
rm: remove write-protected regular empty file ‘a.centos’? y
-bash-4.2$ ll
total 0
-rw-rw-r--. 1 centos mygrp  0 Mar 18 22:18 aa.centos
-rw-rw-r--. 1 gentoo gentoo 0 Mar 18 22:17 a.gentoo

```

##### Sticky
> 对于一个多人可写的目录，如果设置了 Sticky，则每个用户仅能删除自己的文件
> tmp 目录本身就有粘滞位
> /var/tmp 目录本身就有粘滞位
> chmod o + t DIR ...
> chmod o - t DIR ...
```bash
[root@localhost tmp]# chmod o+t test
[root@localhost tmp]# ll -ldh test/
drwxrwsr-t. 2 root mygrp 37 Mar 18 22:29 test/
[root@localhost tmp]# su centos
Welcome Connect UID: 1001
[centos@localhost tmp]$ cd test
[centos@localhost test]$ ll
total 0
-rw-rw-r--. 1 centos mygrp  0 Mar 18 22:18 aa.centos
-rw-rw-r--. 1 gentoo gentoo 0 Mar 18 22:17 a.gentoo
[centos@localhost test]$ rm a.gentoo
rm: remove write-protected regular empty file ‘a.gentoo’? y
rm: cannot remove ‘a.gentoo’: Operation not permitted
```

##### 其他
> USID、UGID、Sticky 权限位的大小写
> 如果是大写，则原来的属主、属组、其他组有执行权限

```bash
[root@localhost tmp]# umask
0022
```

##### if
```bash
if [ $# -lt 1 ]
then
   echo "A least one parameter"
   exit 1
else
   if id $1 > /dev/null
   then
      echo "$1 exists"
      exit 0
   else
      useradd $1 && echo "$1" | passwd --stdin $1 &> /dev/null && exit 0 || exit 1
   fi
fi
```
### Linux磁盘管理(03)_recv


### linux文件系统管理(04)_recv

### 压缩、解压缩及归档工具
> compress \ uncompress : z
- gzip \ gunzip : gz
> 算法LZ77，压缩比不是非常高, gzip 会自动删除原文件
> -d

```bash
[root@localhost ~]# ls -l
total 240
-rw-------. 1 root root   2897 Mar 17 23:03 anaconda-ks.cfg
-rw-------. 1 root root 238167 Mar 18 01:09 messages
[root@localhost ~]# gzip messages
[root@localhost ~]# ls -l
total 36
-rw-------. 1 root root  2897 Mar 17 23:03 anaconda-ks.cfg
-rw-------. 1 root root 31229 Mar 18 01:09 messages.gz
```

```bash
[root@localhost ~]# ll -h
total 36K
-rw-------. 1 root root 2.9K Mar 17 23:03 anaconda-ks.cfg
-rw-------. 1 root root  31K Mar 18 01:09 messages.gz
[root@localhost ~]# gunzip messages.gz
[root@localhost ~]# ll -h
total 240K
-rw-------. 1 root root 2.9K Mar 17 23:03 anaconda-ks.cfg
-rw-------. 1 root root 233K Mar 18 01:09 messages
```


> bzip2 \ bunzip2 : bz
> xz \ unxz : xz
> zip \ unzip : zip
