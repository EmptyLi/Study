### 第2章 网络客户端 (Network Clients)
#### 2.1 理解 socket
> 文件描述符一般是指一个文件或某个类似文件的实体
> 把对网络的支持加入操作系统，是以一种扩展现有文件描述符结构的方法来实现的。新的系统调用被加入并和socket一起工作，而很多现有的系统调用同样能和socket一起工作。因此，一个socket允许您使用标准的操作系统和其他的计算机，以及自己机器上的不同进程来通信。

#### 2.2 建立 socket
> 首先，需要建立一个实际的 socket 对象

1、通信类型 AF_INET(对应IPV4)
> 指明用什么协议来传输数据

2、协议家族
> 定义数据如何被传输
> TCP通信的SOCK_STREAM UDP通信的SOCK_DGRAM
```python
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
```

> 其次，需要把它连接到远程服务器上。提供一个tuple，它包含远程主机名或IP地址和端口。
```python
s.connect(('www.baidu.com', 80))
```
##### 2.2.1 寻找端口号
> python的socket库包含一个 getServbyname() 的函数，它可以自动地查询。在UNIX系统中，可以在/etc/services目录下找到这个列表
> 为了查询，需要两个参数：协议名和端口名。端口名是一个字符串
```python
port = socket.getServbyname('http', 'tcp')
```

#### 2.2.2 从socket获取信息
```python
# 本身的IP地址和端口号
s.getsockname()
# 远程机器的IP和端口号
s.getpeername()
```

### 2.3 利用socket通信
> 文件类对象一般用于面向线型的协议，因为它能通过提供的 readline() 函数自动地为您处理大多数的解析。然而，文件类对象一般只对TCP连接工作得很好，对UDP连接反而不是很好。因为TCP连接的行为更像是标准的文件，它们保证数据接收的精确性，并且和文件一样是以字节流形式运转的。而UDP并不像文件那样以字节流形式运转。相反，它是一种基于信息包的通信。文件类对象没有办法操作每个基本的信息包，因而建立、发送和接收UDP信息包的基本机制是不能工作的，并且错误检查也是非常困难的。

### 2.4 处理错误
#### 2.4.1 socket异常
- 与一般 I/O 和通信问题有关的 socket.error
- 与查询地址信息有关的 socket.gaierror
- 与其他地址错误有关的 socket.herror
- 与在一个 socket 上调用 settimeout() 后，处理超时的 socket.timeout
```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time    : 2018/5/23 14:06
# @Author  : RayLee
# @Email   : lirui@chinacscs.com
# @File    : socketerrors.py
# @version : python3.6

import socket, sys
host = sys.argv[1]
textport = sys.argv[2]
filename = sys.argv[3]

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error as e:
    print('Strange error creating socket: %s' % e)
    sys.exit(1)

try:
    port = int(textport)
except ValueError:
    try:
        port = socket.getservbyname(textport, 'tcp')
    except socket.error as e:
        print("Couldn't find your port: %s" % e)
        sys.exit(1)

try:
    s.connect((host, port))
except socket.gaierror as e:
    print("Address-related error connecting to server: %s" % e)
    sys.exit(1)
except socket.error as e:
    print("Connection error: %s" % e)
    sys.exit(1)

try:
    s.sendall("GET %S HTTP/1.0\r\rn\r\n" % filename)
except socket.error as e:
    print("Error sending data: %s" % e)
    sys.exit(1)

while 1:
    try:
        buf = s.recv(2048)
    except socket.error as e:
        print("Error receving data: %s" % e)
        sys.exit(1)

    if not len(buf):
        break

    sys.stdout.write(buf)
```
#### 2.4.2 遗漏的错误
> 在客户端连接与服务器写客户端请求的这段时间里，如果远程服务器断开连接
> 对于很多操作系统来说，有时候在网络上发送数据的调用会在远程服务器确保已经收到信息之前返回，因此，很有可能一个来自对sendall()成功调用返回的数据，事实上永远都没有被收到。为了解决这个问题，但结束写操作，应该立刻调用shutdown()函数。这样就会强制清除缓存里面的内容，同时如果有任何问题就会产生一个异常。

```python
try:
    s.shutdown(1)
except socket.error as e:
    print("Error sending data (detected by shutdown): %s" % e)
    sys.exit(1)
```

#### 2.4.3 文件类对象引起的错误
