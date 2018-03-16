查看物理CPU的个数:
```bash
cat /proc/cpuinfo |grep "physical id"|sort |uniq | wc -l
```

查看逻辑CPU的个数:
```bash
cat /proc/cpuinfo | grep "processor"
```

查看CPU是几核:
```bash
cat /proc/cpuinfo | grep "cores"
```

查看CPU的主频:
```bash
cat /proc/cpuinfo | grep MHz
```

CPU型号：
```bash
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
```

操作系统版本：
```bash
cat /etc/*release*
```

查看服务器型号：
```bash
grep 'DMI' /var/log/dmesg
```

没有权限执行这个
```bash
# dmidecode | grep "Product"
```
