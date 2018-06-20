## 关于包的安装、加载及更新、卸载
```r
# 查看可更新包
update.packages()

# 安装下载工具包
install.packages("ggplot2")

# 加载下载工具包
library(ggplot2)

# 分离包，从内存空间中移除
detach("ggplot2")

# 删除，相当于卸载
remove.packages("ggplot2")
```

## 关于R语言软件的更新
```r
# 下载安装工具包
install.packages("installr")

# 加载安装工具包
library(installr)

# 检测是否有最新版的 R软件
check.for.update.R()

# 下载并安装最新版 R 软件
installr()

# 复制旧版 R 中的包到新版 R 中
copy.packages.between.libraries()
```
