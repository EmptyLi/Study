- 3.1. Making a Basic Bar Graph

    > 画一个简单的条线图


```r
library(gcookbook)
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat="identity")
```

    >如果想要X轴的变量连续的话，可以使用factor函数

```r
ggplot(BOD, aes(x=Time, y=demand)) + geom_bar(stat="identity")
```

```r
ggplot(BOD, aes(x=factor(Time), y=demand)) + geom_bar(stat="identity")
```


    > 修改图形的相关信息，条线图的颜色使用fill参数，边框使用colour参数


```r
ggplot(BOD, aes(x=factor(Time), y=demand)) + geom_bar(stat="identity", fill="lightblue")
```

```r
ggplot(BOD, aes(x=factor(Time), y=demand)) + geom_bar(stat="identity", fill="lightblue", colour="black")
```


    > 一般情况下，使用的英式英语的colour，而美式的color会映射到colour上去。

- 3.2. Grouping Bars Together

    > 使用并列的柱形来区分某一维度
    > 对于要分类展示的维度，填充到aes的fill变量中
    > 一定要使用geom_bar(stat="identity", position="dodge")



```r
ggplot(cabbage_exp,aes(x=Date,y=Weight,fill=Cultivar))+geom_bar(stat="identity", position="dodge")

ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(position = "dodge")
Error: stat_count() must not be used with a y aesthetic.
By default, geom_bar uses stat="count" which makes the height of the bar proportion to the number of cases in each group (or if the weight aethetic is supplied, the sum of the weights). If you want the heights of the bars to represent values in the data, use stat="identity" and map a variable to the y aesthetic.
```

    > 使用scale_fill_brewer()函数或者scale_fill_manual()函数来设置柱状的颜色


```r
ggplot(cabbage_exp,aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(stat="identity", position="dodge", colour="red") + scale_fill_brewer(palette="Pastel1")
```

- 3.3. Making a Bar Graph of Counts

    > 统计某一维度的数据量，使用分离变量


```r
ggplot(diamonds, aes(x=cut)) + geom_bar()
ggplot(diamonds, aes(x=cut)) + geom_bar(stat="count")
ggplot(diamonds, aes(x=cut)) + geom_bar(stat="count", fill="lightblue")
ggplot(diamonds, aes(x=cut)) + geom_bar(stat="count", fill="lightblue", colour="green")
```

    > 统计某一维度的数据量，使用连续变量


```r
ggplot(diamonds, aes(x=carat)) + geom_bar()
```

- 3.4. Using Colors in a Bar Graph

```r
upc <- subset(uspopchange, rank(Change)>40)
ggplot(upc, aes(x=State, y=Change, fill=Region)) + geom_bar(stat="identity")
```

```r
ggplot(upc, aes(x=reorder(Abb, Change), y=Change, fill=Region)) + geom_bar(stat="identity", colour="black") + scale_fill_manual(values=c("#669933", "#FFCC66")) + xlab("State")
```

- 3.5. Coloring Negative and Positive Bars Differently

    > 正负值使用不同的颜色

```r
csub <- subset(climate, Source=="Berkeley" & Year >= 1900)
csub$pos <- csub$Anomaly10y >= 0
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) + geom_bar(stat="identity", position="identity")
```

    > size 参数设定线宽, 设置指导不显示


```r
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
geom_bar(stat="identity", position="identity", colour="black", size=0.25) +
scale_fill_manual(values=c("#CCEEFF", "#FFDDDD"), guide=FALSE)
```

    > 设定指导


```r
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
geom_bar(stat="identity", position="identity", colour="black", size=0.25) +
scale_fill_manual(values=c("#CCEEFF", "#FFDDDD"))
```

- 3.6. Adjusting Bar Width and Spacing

    > 设定间距宽

```r
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat="identity")
```

```r
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat="identity", width=0.5)
```
```r
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat="identity", width=1)
```

```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
geom_bar(stat="identity", width=0.5, position="dodge")
```

```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
geom_bar(stat="identity", width=0.5, position=position_dodge(0.7))
```

    > position="dodge" 是 position=position_dodge()的缩写
    > 一般position_dodge()的默认值为0.9

    > 效果完全一致，geom_bar中的width的默认值与position_dodge()中的width默认值一致


```r
geom_bar(position="dodge")
geom_bar(width=0.9, position=position_dodge())
geom_bar(position=position_dodge(0.9))
geom_bar(width=0.9, position=position_dodge(width=0.9))
```

- 3.7. Making a Stacked Bar Graph

```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(stat="identity")
```


```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
geom_bar(stat="identity") +
guides(fill=guide_legend(reverse=TRUE))
```


```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar, order=desc(Cultivar))) +
geom_bar(stat="identity")
```

```r
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
geom_bar(stat="identity", colour="black") +
guides(fill=guide_legend(reverse=TRUE)) +
scale_fill_brewer(palette="Pastel1")
```


- 3.8. Making a Proportional Stacked Bar Graph

```r
library("plyr")
ce <- ddply(cabbage_exp, "Date", transform, percent_weight = Weight / sum(Weight) * 100)
ggplot(ce, aes(x=Date, y=percent_weight, fill=Cultivar)) + geom_bar(stat="identity")
```

```r
ggplot(ce, aes(x=Date, y=percent_weight, fill=Cultivar)) +
geom_bar(stat="identity", colour="black") +
guides(fill=guide_legend(reverse=TRUE)) +scale_fill_brewer(palette="Pastel1")
```


- 3.9. Adding Labels to a Bar Graph

```r
ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
geom_bar(stat="identity") +
geom_text(aes(label=Weight), vjust=1.5, colour="white")
```



```r
ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
geom_bar(stat="identity") +
geom_text(aes(label=Weight), vjust=-0.2)
```
