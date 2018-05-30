# 创建数据集
my_vector <- c(3,12,5,18,45)
names(my_vector) <- c("A", "B", "C", "D", "E")

# 绘制基本条形图
barplot(my_vector, col=rgb(0.2, 0.4, 0.6, 0.6), xlab="category")

# 绘制水平条形图
barplot(my_vector, col=rgb(0.2, 0.4, 0.6, 0.6), horiz=T, las=1)

# 绘制带纹理的条形图
barplot(c(2,5,4,6), density=c(5,10,20,30), angle=c(0,45,90,11), col="brown", names.arg=c("A", "B", "C", "D"))

# 绘制堆砌和分组条形图
