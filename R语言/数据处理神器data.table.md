```
基础字符串处理函数——stringr
绘图系统：plot——ggplot2
代码风格：函数嵌套——管道函数（`%>%`）
列表处理：list（自建循环）——rlist
json处理：Rjson+RJSONIO——jsonlite
数据抓取：RCurl+XML——httr+xml2
循环任务：for/while——apply——plyr::a_ply——并行运算（foreach、parallel）
切片索引：subset——dplyr::select+filter
聚合运算：aggregate——plyr::ddply+mutate——dplyr::group_by+summarize
数据联结：merge——plyr::join——dplyr::left/right/inner/outer_join
数据塑型：plyr::melt/dcast——tidyr::gather/spread
```

- 1、I/O性能
```r
#清空内存
rm(list=ls())
gc()

#使用传统的I/O函数read_csv2进行导入：
setwd("D:/Python/citibike-tripdata/")
system.time(mydata1 <- read.csv("2015-citibike-tripdata.csv",stringsAsFactors = FALSE,check.names = FALSE))
object.size(mydata1)

# 使用data.table内的I/O函数进行导入
rm(list=ls())
gc()

library("data.table")
system.time(mydata1 <- fread("2015-citibike-tripdata.csv") )
```

- 2、索引切片聚合
> data.table中提供了将行索引、列切片、分组功能于一体的数据处理模型。
```r
DT[i,j,by]
```
> 如果这个过程是SQL中是由select …… from …… where …… groupby …… having 来完成的，在R的其他基础包中起码也是分批次完成的。
```r
dplyr::fliter() %>% select() %>% group_by() %>% summarize()
```

```r
mydata <- fread("https://raw.githubusercontent.com/wiki/arunsrinivasan/flights/NYCflights14/flights14.csv")
```
> 使用fread函数导入之后便会自动转化为data.table对象，这是data.table所特有的高性能数据对象，同时继承了data.frame传统数据框类，也意味着他能囊括很多数据框的方法和函数调用

- data.table行索引
```r
carrier <- unique(mydata$carrier)
[1] "AA" "AS" "B6" "DL" "EV" "F9" "FL" "HA" "MQ" "VX" "WN" "UA" "US" "OO"

tailnum <- sample(unique(mydata$tailnum),5)
[1] "N332AA" "N813MQ" "N3742C" "N926EV" "N607SW"

origin  <- unique(mydata$origin)
[1] "JFK" "LGA" "EWR"

dest    <- sample(unique(mydata$dest),5)
[1] "BWI" "OAK" "DAL" "ATL" "ALB"``

mydata[carrier == "AA" ]
#等价于
mydata[carrier == "AA",]
#行索引可以直接引用列表，无需加表明前缀，这一点儿数据框做不到,而且i,j,by三个参数对应的条件支持模糊识别，无论加“,”与否都可以返回正确结果。

mydata[carrier %in% c("AA","AS"),]

支持在行索引位置使用%in% 函数。
```
- data.table列索引
> 列索引与数据框相比操作体验差异比较大，data.table的列索引摒弃了data.frame时代的向量化参数，而使用list参数进行列索引。
```r
mydata[,list(carrier,tailnum)]
```

> 为了操作体验更佳，这里的list可以简化为一个英文句点符号。
```r
mydata[,.(carrier,tailnum)]
```

- 行列同时索引毫无压力。
```r
mydata[carrier %in% c("AA","AS"),.(carrier,tailnum)]
```

- 列索引的位置不仅支持列名索引，可以直接支持内建函数操作。
```r
mydata[,.(flight/1000,carrier,tailnum)]
```

- 支持直接在列索引位置新建列，赋值符号为:=
```r
mydata[,delay_all := dep_delay+arr_delay]
#销毁某一列：
mydata[,delay_all := NULL]
```

- 批量新建列
```r
mydata[,c("delay_all","delay_dif") := .((dep_delay+arr_delay),(dep_delay-arr_delay))]
等价于写法2：
mydata[,`:=`(delay_all = dep_delay+arr_delay,delay_dif =dep_delay-arr_delay )]
#销毁新建列：
mydata[,c("delay_all","delay_dif") := NULL]
```
> 注意以上新建列时，如果只有一列，列名比较自由，写成字符串或者变量都可以，但是新建多列，必须严格按照左侧列名为字符串向量，右侧为列表的模式，当然你也可以使用第二种写法。
```r
DT[,`:=`(varname1 = statement1 ,varname1 = statement2)]
```

- 基本的统计函数都可以直接支持。
```r
mydata[carrier %in% c("AA","AS"),.(sum(dep_delay),mean(arr_delay))]
       V1       V2
1: 228913 5.263841

mydata[carrier %in% c("AA","AS"),.(dep_delay,mean(arr_delay))]

mydata[carrier %in% c("AA","AS") & dep_delay %between% c(500,1000),.(dep_delay,arr_delay)]
```

```r
mydata[,.(sum(dep_delay),mean(arr_delay)),by = carrier]
```

- 多分组聚合
```r
mydata[,.(sum(dep_delay),mean(arr_delay)),by = .(carrier,origin)]
```
- 多分组计数
```r
mydata[,.N,by = .(carrier,origin)]
```

- 自定义名称
```r
mydata[,.(dep_delay_sum = sum(dep_delay),arr_delay_mean = mean(arr_delay)),by = carrier]
mydata[,.(dep_delay_sum = sum(dep_delay),arr_delay_mean = mean(arr_delay)),by = .(carrier,origin)]
mydata[,.(carrier_n = .N),by = .(carrier,origin)]
```

- 排序行
> setorder函数作用于mydata本身，运行无输出。如果想要运行的同时进行输出则可以在结尾加上[]
```R
setorder(mydata,carrier,-arr_delay)
setorder(mydata,carrier,-arr_delay)[]

sample(names(mydata),length(names(mydata)))
setcolorder(mydata,sample(names(mydata),length(names(mydata))))
mydata[carrier == "AA",lapply(.SD, mean),by=.(carrier,origin,dest),.SDcols=c("arr_delay","dep_delay")]
# by=.(carrier,origin,dest) 先按照三个维度进行全部的分组；
# .SDcols=c("arr_delay","dep_delay")则分别在筛选每一个子数据块儿上的特定列；
# lapply(.SD, mean)则将各个子块的对应列应用于均值运算，并返回最终的列表。
```
- 数据合并
```R
DT <- data.table(x=rep(letters[1:5],each=3), y=runif(15))
DX <- data.table(z=letters[1:3], c=runif(3))
setkey(DT,x)
setkey(DX,z)

DT[DX]
```
> 就是如此简单，连接的执行逻辑是，内侧是左表，外侧是右表，所以是DX left join DT
> 如果没有设置主键，需要显式声明内部的on参数，指定连接主键，单主键必须在左右表中名称一致。
> 当然你要是特别不习惯这种用法，还是习惯使用merge的话，data.table仍然是支持的，因为他本来就继承了数据框，支持所有针对数据框的函数调用。
