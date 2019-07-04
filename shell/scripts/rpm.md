- rpm包的安装
```bash
rpm {-i | --install} [install_options] rpm_package
   -v          verbose
   -vv         more verbose
   -h          以 hash 的格式显示安装的进度 \# 执行进度

   # 只安装单独的包，对于依赖关系的包不生效
   rpm -ivh packagename

   # 测试安装，但并不真正执行安装过程
   rpm -ivh --test packagename

   # 忽略依赖关系，避免出现循环依赖
   rpm -ivh --nodeps packagename

   # 重新安装，有可能将以前的配置给覆盖
   rpm -ivh --replacepkgs packagename

   # 忽略系统版本
   rpm -ivh --ignoreos packagename

   # 不检查包的完整性
   rpm -ivh --nodigest packagename

   # 不检查包的来源合法性
   rpm -ivh --nosignature packagename

   # 安装程序包，但是不执行程序包中的脚本
   rpm -ivh --noscripts packagename

      --nopre 安装前脚本
      --nopost 安装后脚本
      --nopreun 卸载前脚本
      --nopostun 卸载后脚本

```

- rpm包的升级
```bash
rpm {-U|--upgrade} [install-options] PACKAGE_FILE
rpm {-F|--freshen} [install-options] PACKAGE_FILE

   upgrade: 安装有旧版程序包，则“升级”；如果不存在旧版程序包，则“安装”
   freshen: 安装有旧版程序包，则“升级”；如果不存在旧版程序包，则不执行升级操作

   rpm -Uvh packagename
   rpm -Fvh packagename

   options 同安装

   # 将包降级
   rpm -Uvh --oldpackage packagename

   # 强制更新
   rpm -Uvh --force packagename
```
> 要不要对内核升级操作， Linux支持多内核版本并存，因此，直接安装新版本内核
```bash
[root@localhost ~]# uname -r
3.10.0-327.el7.x86_64
```
> 如果原程序包的配置文件安装后曾被修改，升级时，新版本的提供的同一配置文件并不会直接覆盖老版本的配置文件，而把新版版的文件重命名(filename.rpmnew)后保留。

- 查询操作
```bash
rpm {-q|--query} [select-options] [query-options]
   查询选项
      -a          所有包
      -f          查询指定的文件由哪个程序包生成
      -g          查询指定包组的程序包
      --whatprovides 查询指定的文件或功能由哪个包生成
      --whatrequires 查询指定的功能由被哪些功能所依赖
      -p          对尚未安装的程序包文件进行查询

      # 查询已经安装的包
      rpm -qa | grep 'string'

      # 查询指定的文件由哪个程序包生成
      [root@localhost ~]# rpm -qf /etc/issue
      centos-release-7-2.1511.el7.centos.2.10.x86_64

   挑选选项
      --changelog       rpm包的制作日志
      -c                查看配置文件
      --conflicts       查看冲突的选项
      -d                查看文档
      -i
      --info
      -l                查看指定的程序包安装后生成的所有文件
      --scripts         程序包自带的脚本片段
      --triggers        显式触发脚本
      -R                查询指定的程序包所依赖的能力
      --whatprovides    列出指定程序包所提供的能力

      # 查看一个服务的配置文件
      [root@localhost ~]# rpm -q -c bash
      /etc/skel/.bash_logout
      /etc/skel/.bash_profile
      /etc/skel/.bashrc

      # 查看一个命令的文档
      [root@localhost ~]# rpm -qd bash
      /usr/share/doc/bash-4.2.46/COPYING
      /usr/share/info/bash.info.gz
      /usr/share/man/man1/..1.gz
      /usr/share/man/man1/:.1.gz
      /usr/share/man/man1/[.1.gz
      /usr/share/man/man1/alias.1.gz
      /usr/share/man/man1/bash.1.gz
      /usr/share/man/man1/bashbug-64.1.gz
      /usr/share/man/man1/bashbug.1.gz
      /usr/share/man/man1/bg.1.gz
      /usr/share/man/man1/bind.1.gz
      /usr/share/man/man1/break.1.gz
      /usr/share/man/man1/builtin.1.gz
      /usr/share/man/man1/builtins.1.gz
      /usr/share/man/man1/caller.1.gz
      /usr/share/man/man1/cd.1.gz

      # 查看命令的详细信息
      [root@localhost ~]# rpm -qi bash
      Name        : bash
      Version     : 4.2.46
      Release     : 19.el7
      Architecture: x86_64
      Install Date: Sat 17 Mar 2018 11:45:37 PM PDT
      Group       : System Environment/Shells
      Size        : 3663618
      License     : GPLv3+
      Signature   : RSA/SHA256, Wed 25 Nov 2015 06:14:53 AM PST, Key ID 24c6a8a7f4a80eb5
      Source RPM  : bash-4.2.46-19.el7.src.rpm
      Build Date  : Thu 19 Nov 2015 09:04:53 PM PST
      Build Host  : worker1.bsys.centos.org
      Relocations : (not relocatable)
      Packager    : CentOS BuildSystem <http://bugs.centos.org>
      Vendor      : CentOS
      URL         : http://www.gnu.org/software/bash
      Summary     : The GNU Bourne Again shell
      Description :
      The GNU Bourne Again shell (Bash) is a shell or command language
      interpreter that is compatible with the Bourne shell (sh). Bash
      incorporates useful features from the Korn shell (ksh) and the C shell
      (csh). Most sh scripts can be run by bash without modification.

      # 程序包生成的文件
      rpm -qi -p packagename
```

- 卸载程序包
```bash
rpm {-e|--erase} [--allmatches] [--justdb] [--nodeps] [--noscripts]
   --nodeps          忽略依赖关系
   --test            只是测试，并不是真的卸载

   # 卸载一个软件
   rpm -e sh

   # 忽略依赖关系
   rpm -e --nodeps sh
```

- 校验程序包
```bash
rpm {-V|--verify} [select-options] [verify-options]

   rpm -ivh zsh
   rpm -ql zsh
   rpm -V zsh

   [root@localhost ~]# rpm -V zsh
   S.5....T.    /usr/share/zsh/5.0.2/functions/_precommand

   S file Size differs
   M Mode differs (includes permissions and file type)
   5 digest (formerly MD5 sum) differs
   D Device major/minor number mismatch
   L readLink(2) path mismatch
   U User ownership differs
   G Group ownership differs
   T mTime differs
   P caPabilities differ

   可靠手段拿到公钥
   完整性 SHA256
   合法性 RSA
      导入密钥文件
      rpm --import /path/from/pgp-pkgs-file

```
- 初始化数据库
```bash
rpm {--initdb | --rebuilddb}
   initdb：初始化
      如果事先不存在数据库，则新创建，否则，不执行任何操作

   rebuilddb：重建
      无论当前存在与否，直接重新创建数据库
```
