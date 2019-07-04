使用set -u
当你使用未初始化的变量时，让bash自动退出。你也可以使用可读性更强一点的set -o nounset。

使用set -e
一但有任何一个语句返回非真的值，则退出bash。
更加可读的版本：set -o errexit

set -e  表示有报错即退出，
set +e  表示关闭这种设置。
set -e 等价于 set -o errexit ,
set +e 等价于 set +o errexit 

command
if [ "$?"-ne 0]; then echo "command failed"; exit 1; fi
可以替换成：
command || { echo "command failed"; exit 1; }
或者使用：
if ! command; then echo "command failed"; exit 1; fi

准备好处理文件名中的空格
if [ $filename = "foo" ];
当$filename变量包含空格时就会挂掉。可以这样解决：
if [ "$filename" = "foo" ];
使用$@变量时，你也需要使用引号，因为空格隔开的两个参数会被解释成两个独立的部分。

当你编写的脚本挂掉后，文件系统处于未知状态。比如锁文件状态、临时文件状态或者更新了一个文件后在更新下一个文件前挂掉。如果你能解决这些问题，无论是 删除锁文件，又或者在脚本遇到问题时回滚到已知状态，你都是非常棒的。幸运的是，bash提供了一种方法，当bash接收到一个UNIX信号时，运行一个 命令或者一个函数。可以使用trap命令。
trap command signal [signal ...]
你可以链接多个信号（列表可以使用kill -l获得），但是为了清理残局，我们只使用其中的三个：INT，TERM和EXIT。你可以使用-as来让traps恢复到初始状态。
信号描述


INT
Interrupt - 当有人使用Ctrl-C终止脚本时被触发
TERM
Terminate - 当有人使用kill杀死脚本进程时被触发
EXIT
Exit - 这是一个伪信号，当脚本正常退出或者set -e后因为出错而退出时被触发




当你使用锁文件时，可以这样写：
if [ ! -e $lockfile ]; then
   touch $lockfile
   critical-section
   rm $lockfile
else
   echo "critical-section is already running"
fi
当最重要的部分(critical-section)正在运行时，如果杀死了脚本进程，会发生什么呢？锁文件会被扔在那，
而且你的脚本在它被删除以前再也不会运行了。解决方法：
if [ ! -e $lockfile ]; then
   trap " rm -f $lockfile; exit" INT TERM EXIT
   touch $lockfile
   critical-section
   rm $lockfile
   trap - INT TERM EXIT
else
   echo "critical-section is already running"
fi
现在当你杀死进程时，锁文件一同被删除。注意在trap命令中明确地退出了脚本，否则脚本会继续执行trap后面的命令。

竟态条件
在上面锁文件的例子中，有一个竟态条件是不得不指出的，它存在于判断锁文件和创建锁文件之间。一个可行的解决方法
是使用IO重定向和bash的noclobber模式，重定向到不存在的文件。我们可以这么做：
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then
   trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
   critical-section
   rm -f "$lockfile"
   trap - INT TERM EXIT
else
   echo "Failed to acquire lockfile: $lockfile"
   echo "held by $(cat $lockfile)"
fi
更复杂一点儿的问题是你要更新一大堆文件，当它们更新过程中出现问题时，你是否能让脚本挂得更加优雅一些。你想确认
那些正确更新了，哪些根本没有变化。比如你需要一个添加用户的脚本。
add_to_passwd $user
cp -a /etc/skel /home/$user
chown $user /home/$user -R
当磁盘空间不足或者进程中途被杀死，这个脚本就会出现问题。在这种情况下，你也许希望用户账户不存在，而且他的文件也应该被删除。
rollback() {
del_from_passwd $user
if [ -e /home/$user ]; then
rm -rf /home/$user
fi
exit
}

trap rollback INT TERM EXIT
add_to_passwd $user

cp -a /etc/skel /home/$user
chown $user /home/$user -R
trap - INT TERM EXIT
在脚本最后需要使用trap关闭rollback调用，否则当脚本正常退出的时候rollback将会被调用，那么脚本等于什么都没做。

保持原子化
又是你需要一次更新目录中的一大堆文件，比如你需要将URL重写到另一个网站的域名。你也许会写：
for file in $(find /var/www -type f -name "*.html");
do
   perl -pi -e 's/www.example.net/www.example.com/' $file
done
如果修改到一半是脚本出现问题，一部分使用www.example.com，而另一部分使用www.example.net。
你可以使用备份和trap解决，但在升级过程中你的网站URL是不一致的。
解决方法是将这个改变做成一个原子操作。先对数据做一个副本，在副本中更新URL，再用副本替换掉现在工作的版本。
你需要确认副本和工作版本目录在同一个磁盘分区上，这样你就可以利用Linux系统的优势，
它移动目录仅仅是更新目录指向的inode节点。
cp -a /var/www /var/www-tmp
for file in $(find /var/www-tmp -type -f -name "*.html"); do
perl -pi -e 's/www.example.net/www.example.com/' $file
done
mv /var/www /var/www-old
mv /var/www-tmp /var/www
