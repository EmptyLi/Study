# 复杂HTML解析
## 2.1　不是一直都要用锤子
```python
from urllib.request import urlopen
from bs4 import BeautifulSoup
url = 'http://www.pythonscraping.com/pages/warandpeace.html'
html = urlopen(url)
bsObj = BeautifulSoup(html)
print(bsObj)

# 用 findAll 函数抽取只包含在 <span class="green"></span> 标签里的文字
nameList = bsObj.findAll("span", {"class": "green"})
for name in nameList:
    print(name.get_text())
```

> .get_text() 会把你正在处理的 HTML 文档中所有的标签都清除，然后返回一个只包含文字的字符串。 假如你正在处理一个包含许多超链接、段落和标签的大段源代码， 那么 .get_text() 会把这些超链接、段落和标签都清除掉，只剩下一串不带标签的文字。

### 2.2.1 BeautifulSoup的find()和findAll()
```python
findAll(tag, attributes, recursive, text, limit, keywords)

find(tag, attributes, recursive, text, keywords)
```
- 参数 tag
> 你可以传一个标签的名称或多个标签名称组成的 Python列表做标签参数。
> 通过标签参数 tag 把标签列表传到 .findAll() 里获取一列标签，其实就是一个“或”关系的过滤器

- 参数 attributes
> 字典封装一个标签的若干属性和对应的属性值

- 参数 recursive
> 如果 recursive 设置为 True， findAll 就会根据你的要求去查找标签参数的所有子标签，以及子标签的子标签。如果 recursive 设置为 False， findAll 就只查找文档的一级标签。 findAll默认是支持递归查找的（recursive 默认值是 True）；一般情况下这个参数不需要设置，除非你真正了解自己需要哪些信息，而且抓取速度非常重要，那时你可以设置递归参数。

- 参数 text
> 它是用标签的文本内容去匹配，而不是用标签的属性

- 参数 limit
> find 其实等价于 findAll 的 limit 等于1 时的情形。如果你只对网页中获取的前 x 项结果感兴趣，就可以设置它。但是要注意，这个参数设置之后，获得的前几项结果是按照网页上的顺序排序的，未必是你想要的那前几项。

- 参数 keyword
> 可以让你选择那些具有指定属性的标签

**关键词参数的注意事项**
```python
# 关键词参数 keyword
bsObj.findAll(id="text")
bsObj.findAll("", {"id":"text"})

# class 属性查找标签的时候，因为 class 是 Python 中受保护的关键字
bsObj.findAll(class_="green")
bsObj.findAll("", {"class":"green"})
```

### 2.2.2　其他BeautifulSoup对象
#### BeautifulSoup 对象
> 前面代码示例中的 bsObj

#### 标签 Tag 对象
> BeautifulSoup 对象通过 find 和 findAll，或者直接调用子标签获取的一列对象或单个对象

#### NavigableString 对象
> 用来表示标签里的文字， 不是标签（有些函数可以操作和生成 NavigableString 对象，而不是标签对象）。

#### Comment 对象
> 用来查找 HTML 文档的注释标签， \<!-- 像这样 -->

### 2.2.3　导航树
#### 1. 处理子标签和其他后代标签
> 在 BeautifulSoup 库里， 孩子（child）和后代（descendant）有显著的不同：和人类的家谱一样，子标签就是一个父标签的下一级，而后代标签是指一个父标签下面所有级别的标签。
