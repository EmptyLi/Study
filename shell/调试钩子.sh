if [ “$DEBUG” = “true” ]; then
   echo “debugging”  #此处可以输出调试信息
fi

这样的代码块通常称之为“调试钩子”或“调试块”。在调试钩子内部可以输出任何您想输出的调试信息，
使用调试钩子的好处是它是可以通过DEBUG变量来控制的，在脚本的开发调试阶段，可以先执行
export DEBUG=true
命令打开调试钩子，使其输出调试信息，而在把脚本交付使用时，也无需再费事把脚本中的调试语句一一删除。

-n 只读取shell脚本，但不实际执行
-x 进入跟踪方式，显示所执行的每一条命令
-c "string" 从strings中读取命令

“-n”可用于测试shell脚本是否存在语法错误，但不会实际执行命令。在shell脚本编写完成之后，实际执行之前，
首先使用“-n”选项来测试脚本是否存在语法错误是一个很好的习惯。因为某些shell脚本在执行时会对系统环境产生
影响，比如生成或移动文件等，如果在实际执行才发现语法错误，您不得不手工做一些系统环境的恢复工作才能继续
测试这个脚本。

“-c”选项使shell解释器从一个字符串中而不是从一个文件中读取并执行shell命令。当需要临时测试一小段脚本的
执行结果时，可以使用这个选项，如下所示：
sh -c 'a=1;b=2;let c=$a+$b;echo "c=$c"'

"-x"选项可用来跟踪脚本的执行，是调试shell脚本的强有力工具。“-x”选项使shell在执行脚本的过程中把它实际
执行的每一个命令行显示出来，并且在行首显示一个"+"号。 "+"号后面显示的是经过了变量替换之后的命令行的内容，
有助于分析实际执行的是什么命令。 “-x”选项使用起来简单方便，可以轻松对付大多数的shell调试任务,应把其当作
首选的调试手段。

前面有“+”号的行是shell脚本实际执行的命令，前面有“++”号的行是执行trap机制中指定的命令，其它的行则是输出信息。

shell的执行选项除了可以在启动shell时指定外，亦可在脚本中用set命令来指定。 "set -参数"表示启用某选项，"set +参数"
表示关闭某选项。有时候我们并不需要在启动时用"-x"选项来跟踪所有的命令行，这时我们可以在脚本中使用set命令，如以下
脚本片段所示：

set -x　　　 #启动"-x"选项
要跟踪的程序段
set +x　　　　 #关闭"-x"选项

set命令同样可以使用上一节中介绍的调试钩子—DEBUG函数来调用，这样可以避免脚本交付使用时删除这些调试语句的麻烦，
如以下脚本片段所示：

DEBUG set -x　　　 #启动"-x"选项
要跟踪的程序段
DEBUG set +x　　　 #关闭"-x"选项

"-x"执行选项是目前最常用的跟踪和调试shell脚本的手段，但其输出的调试信息仅限于进行变量替换之后的每一条实际执行的命令
以及行首的一个"+"号提示符，居然连行号这样的重要信息都没有，对于复杂的shell脚本的调试来说，还是非常的不方便。幸运的是，
我们可以巧妙地利用shell内置的一些环境变量来增强"-x"选项的输出信息，下面先介绍几个shell内置的环境变量：



$LINENO
代表shell脚本的当前行号，类似于C语言中的内置宏__LINE__

$FUNCNAME
函数的名字，类似于C语言中的内置宏__func__,但宏__func__只能代表当前所在的函数名，而$FUNCNAME的功能更强大，它是一个
数组变量，其中包含了整个调用链上所有的函数的名字，故变量${FUNCNAME[0]}代表shell脚本当前正在执行的函数的名字，而变量
${FUNCNAME[1]}则代表调用函数${FUNCNAME[0]}的函数的名字，余者可以依此类推。

$PS4
主提示符变量$PS1和第二级提示符变量$PS2比较常见，但很少有人注意到第四级提示符变量$PS4的作用。我们知道使用“-x”执行选项
将会显示shell脚本中每一条实际执行过的命令，而$PS4的值将被显示在“-x”选项输出的每一条命令的前面。在Bash Shell中，缺省的$PS4
的值是"+"号。(现在知道为什么使用"-x"选项时，输出的命令前面有一个"+"号了吧？)。

利用$PS4这一特性，通过使用一些内置变量来重定义$PS4的值，我们就可以增强"-x"选项的输出信息。例如先执行
export PS4='+{$LINENO:${FUNCNAME[0]}} ',
然后再使用“-x”选项来执行脚本，就能在每一条实际执行的命令前面显示其行号以及所属的函数名。

以下是一个存在bug的shell脚本的示例，本文将用此脚本来示范如何用“-n”以及增强的“-x”执行选项来调试shell脚本。这个脚本中定义了
一个函数
isRoot(),
用于判断当前用户是不是root用户，如果不是，则中止脚本的执行

exp4.sh
#!/bin/bash
isRoot()
{
if [ "$UID" -ne 0 ]
   return 1
else
   return 0
fi
}
isRoot
if ["$?" -ne 0 ]
then
   echo "Must be root to run this script"
   exit 1
else
   echo "welcome root user"
   #do something
fi
