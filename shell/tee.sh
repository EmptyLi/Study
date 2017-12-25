在shell脚本中管道以及输入输出重定向使用得非常多，在管道的作用下，一些命令的执行结果直接成为了
下一条命令的输入。如果我们发现由管道连接起来的一批命令的执行结果并非如预期的那样，就需要逐步检
查各条命令的执行结果来判断问题出在哪儿，但因为使用了管道，这些中间结果并不会显示在屏幕上，给调
试带来了困难，此时我们就可以借助于tee命令了。

tee命令会从标准输入读取数据，将其内容输出到标准输出设备,同时又可将内容保存成文件。

ipaddr=`/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1'| cut -d : -f3 | awk '{print $1}'`
ipaddr=`/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | tee temp.txt | cut -d : -f3 | awk '{print $1}'`
