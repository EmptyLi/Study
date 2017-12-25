# [Oracle Client Install 11g][http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html]

## Installation of ZIP files

1. Download the desired Instant Client ZIP files. All installations require the Basic or Basic Light package.
> 下载包

2. Unzip the packages into a single directory such as /opt/oracle/instantclient_12_2 that is accessible to your application. For example:
> 解压包

```shell
cd /opt/oracle			
unzip instantclient-basic-linux.x64-12.2.0.1.0.zip
```

3. Create the appropriate links for the version of Instant Client, if the links do not exist. For example:
> 切换目录创建软链接

```shell
  cd /opt/oracle/instantclient_12_2
  ln -s libclntsh.so.12.1 libclntsh.so
  ln -s libocci.so.12.1 libocci.so
```

4. Install the libaio package. This is called libaio1 on some Linux distributions.
> 安装 libaio包，有的版本叫 libaio1

```shell
  sudo yum install libaio
```

5. If Instant Client is the only Oracle Software installed on this system then update the runtime link path, for example:
> 设置配置文件

```shell
sudo sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig
```

Alternatively, set the LD_LIBRARY_PATH environment variable prior to running applications. For example:
> 设定 LD_LIBRARY_PATH 参数

```shell
export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2:$LD_LIBRARY_PATH
```

The variable can optionally be added to configuration files such as ~/.bash_profile and to application configuration files such as /etc/sysconfig/httpd.
> 也可以将 LD_LIBRARY_PATH 配置到对应的 .bash_profile文件中

6. If you intend to co-locate optional Oracle configuration files such as tnsnames.ora, sqlnet.ora, ldap.ora, or oraaccess.xml with Instant Client, then create a network/admin subdirectory. For example:
> 要共同协同使用配置文件时，可创建对应的目录

```shell
mkdir -p /opt/oracle/instantclient_12_2/network/admin
```

This is the default Oracle configuration directory for applications linked with this Instant Client.
Alternatively, Oracle configuration files can be put in another, accessible directory. Then set the environment variable TNS_ADMIN to that directory name.

7. To use binaries such as sqlplus from the SQL*Plus package, unzip the package to the same directory as the Basic package and then update your PATH environment variable, for example:
> 安装sqlplus，应该将相关的zip包解压到对应的目录，同时将安装的目录路径配置到 PATH 变量中

```shell
export PATH=/opt/oracle/instantclient_12_2:$PATH
```

8. Start your application.
> 重启你的应用

## Installation of RPM files
1. Download the desired Instant Client RPM packages. All installations require the Basic or Basic Light RPM.
> 下载RPM包

2. Install the packages with yum. For example:
> 使用 yum 安装

```shell
  sudo yum install oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
```

3. If Instant Client is the only Oracle Software installed on this system then update the runtime link path, for example:
> 设置配置文件

```shell
  sudo sh -c "echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf"
  sudo ldconfig
```

Alternatively, set the LD_LIBRARY_PATH environment variable prior to running applications. For example:
> 设定 LD_LIBRARY_PATH 参数

```shell
  export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2:$LD_LIBRARY_PATH
```

The variable can optionally be added to configuration files such as ~/.bash_profile and to application configuration files such as /etc/sysconfig/httpd.
> 也可以将 LD_LIBRARY_PATH 配置到对应的 .bash_profile文件中

4. If you intend to co-locate optional Oracle configuration files such as tnsnames.ora, sqlnet.ora ldap.ora, or oraaccess.xml with Instant Client, then create a network/admin subdirectory under lib/. For example:
> 要共同协同使用配置文件时，可创建对应的目录

```shell
  sudo mkdir -p /usr/lib/oracle/12.2/client64/lib/network/admin
```

This is the default Oracle configuration directory for applications linked with this Instant Client.

Alternatively, Oracle configuration files can be put in another, accessible directory. Then set the environment variable TNS_ADMIN to that directory name.

5. To use binaries such as sqlplus from the SQL*Plus package, use yum to install the package and then update your PATH environment variable, for example:
> 安装sqlplus，应该将相关的zip包解压到对应的目录，同时将安装的目录路径配置到 PATH 变量中

```shell
export PATH=/opt/oracle/instantclient_12_2:$PATH
```

6. Start your application.
> 重启你的应用
