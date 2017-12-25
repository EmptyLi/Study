trap 'command' signal
其中signal是要捕获的信号，command是捕获到指定的信号之后，所要执行的命令。可以用kill –l命令看到
系统中全部可用的信号名，捕获信号后所执行的命令可以是任何一条或多条合法的shell语句，也可以是一个函数名。

shell脚本在执行时，会产生三个所谓的“伪信号”，(之所以称之为“伪信号”是因为这三个信号是由shell产生的，
而其它的信号是由操作系统产生的)，通过使用trap命令捕获这三个“伪信号”并输出相关信息对调试非常有帮助。

EXIT   从一个函数中退出或整个脚本执行完毕
ERR    当一条命令返回非零状态时(代表命令执行不成功)
DEBUG  脚本中每一条命令执行之前

通过捕获EXIT信号,我们可以在shell脚本中止执行或从函数中退出时，输出某些想要跟踪的变量的值，
并由此来判断脚本的执行状态以及出错原因,其使用方法是：

trap 'command' EXIT　或　trap 'command' 0


通过捕获ERR信号,我们可以方便的追踪执行不成功的命令或函数，并输出相关的调试信息，以下是一个捕获ERR信号
的示例程序，其中的$LINENO是一个shell的内置变量，代表shell脚本的当前行号。

exp1.sh
ERRTRAP()
{
   echo "[LINE:$1] Error: Command or function exited with status $?"
}
foo()
{
   return 1;
}

trap 'ERRTRAP $LINENO' ERR
abc
foo

在调试过程中，为了跟踪某些变量的值，我们常常需要在shell脚本的许多地方插入相同的echo语句
来打印相关变量的值，这种做法显得烦琐而笨拙。而通过捕获DEBUG信号，我们只需要一条trap语句
就可以完成对相关变量的全程跟踪。

exp2.sh
#!/bin/bash
trap 'echo “before execute line:$LINENO, a=$a,b=$b,c=$c”' DEBUG
a=1
if [ "$a" -eq 1 ]
then
   b=2
else
   b=1
fi
c=3
echo "end"
