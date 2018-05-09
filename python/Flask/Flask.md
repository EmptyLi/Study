```python
C:\Users\lirui>virtualenv --version
15.1.0
```
### 第二章 程序的基本结构
#### 2.1 初始化
> Flask 程序都必须创建一个程序实例。 Web服务器使用一种名为 Web服务器网关接口的协议，把接收自客户端的所有请求都转交给这个对象处理，程序实例是Flask类的对象
```python
from flask import Flask
app = Flask(__name__)
```
> Flask类的构造函数只有一个必须指定的参数，即程序主模块或包的名字，在大多数程序中， Python的 __name__ 变量就是所需的值

#### 2.2 路由和视图函数
> 客户端把请求发送给 web 服务器，web服务器再把请求发送给Flask程序实例。程序实例需要知道对每个 URL 请求运行哪些代码，所以保存了一个 URL 到 Python 函数的映射关系。处理URL和函数之间关系的程序称为路由
> 使用程序实例提供的 app.route 修饰器，把修饰的函数注册为路由
```python
@app.route('/')
def index():
   return '<h1>Hello World!</h1>'
```
> 函数的返回值称为响应，是客户端接收到的内容。

> 路由中的动态部分
```python
@app.route('/user/<name>')
def user(name):
   return '<h1> hello, %s </h1>' % name
```
> 路由中的动态部分默认使用字符串，不过也可使用类型定义
> /user/<int:id> 只会匹配动态片段id为整数的URL。Flask支持在路由中使用int、float和path类型。path类型也是字符串，但不把斜线视为分隔符，而降其作动态片段的一部分。

#### 2.3 启动服务器
```python
if __name__ == '__main__':
   app.run(debug=True)
```

#### 2.4 一个完整的程序
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
   return '<h1>RayLee</h1>'

@app.route('/user/<name>')
def helloname(name):
   return '<h1>Welcome To %s </h1>' % name

if __name__ == '__main__':
   app.run(debug=True)
```

#### 2.5 请求-响应循环
##### 2.5.1 程序和请求上下文
##### 2.5.2 请求调度
> Flask 使用 app.route 修饰器或者非修饰器形式的 app.add_url_rule()生成映射

#### 2.5.4 响应
> 第一个返回内容
> 第二个返回状态码
> 首部组成的字典，添加到HTTP响应中
> Flask视图函数还可以返回 Response对象,make_response() 函数可以接受1个、2个或3个参数，并返回一个Response对象。
```python
from flask import make_response

@app.route('/')
def index():
   response = make_response('<h1>This Document Carries A Cookie!</h1>')
   response.set_cookie('answer', '42')
   return response
```
> 有一种名为重定向的特殊响应类型。这种响应没有页面文档，只告诉浏览器一个新地址用以加载新页面。重定向经常在Web表单中使用。
> 重定向经常使用302状态码，指向的地址是由 Location 首部提供。重定向响应可以使用 3 个值形式的返回值生成，也可在 Response对象中设定
```python
@app.route('/')
def index():
   return redirect('http://www.baidu.com')
```
> 一种特殊的响应由 abort 函数生成，用于处理错误。
```python
from flask import abort

@app.route('/user/<id>')
def get_user(id):
   user = load_user(id)
   if not user:
      abort(404)
   return '<h1>Hello, %s</h1>' % user.name
```
### 2.6 Flask扩展
```python
from flask.ext.script import Manager
manager = Manager(app)
if __name__ == '__main__':
   manager.run()
```

### 第 3 章 模板
> 模板是一个包含响应文本的文件，其中包含用占位变量表示的动态部分，其具体值只在请求的上下文中才能知道，使用真实值替换变量，再返回最终得到的响应字符串，这一过程称为渲染，为了渲染模板， Flask 使用了一个名为 Jinja2 的强大模板引擎

#### 3.1 Jinja2模板引擎
> Flask 提供的 render_template 函数把 Jinja2 模板引擎集成到了程序中。 render_template函数的第一个参数是模板的文件名。随后的参数都是键值对，表示模板中变量对应的真实值。
```python
from flask import Flask
from flask import render_template
app = Flask(__name__)

@app.route('/')
def index():
   return render_template("index.html")

@app.route('/user/<name>')
def user(name):
   return render_template("user.html", name = name)

if __name__ == "__main__":
   app.run(debug=True)
```

#### 3.1.2 变量
> 在模板中使用的 {{ name }} 结构表示一个变量，它是一种特殊的占位符，告诉模板引擎这个位置的值从渲染模板时使用的数据中获取
> Jinja2 能识别所有类型的变量，甚至一些复杂的类型，例如列表、字典和对象。
```html
<p>A value from a dictionary: {{ mydict['key'] }}</p>
<p>A value from a list: {{ mylist[3] }}</p>
<p>A value from a list, with a variable index : {{ mydict[myintvar] }}</p>
<p>A value from an object's method: {{ myobj.somemethod() }}</p>
```
> 可以使用过滤器修改变量，过滤器名添加在变量名之后，中间使用竖线分隔
```python
Hello, {{ name|capitalize }}
```

|过滤器名|说明|
|-|-|
|safe   |渲染值时不转义   |
|capitalize   |把值的首字母转换成大写，其他字母转换成小写   |
|lower   |把所有值转换成小写形式   |
|upper   |把所有值转换成大写形式   |
|title   |把值中每个单词的首字母都转换成大写   |
|trim   |把值的首尾空格去掉   |
|striptags   |渲染之前把值中所有的HTML标签都删掉   |

#### 3.1.3 控制结构
```python
{% if user %}
   {{ user }}
{% else %}
   Hello, Stranger!
{% endif %}

<ul>
   {% for comment in comments %}
      <li>{{% comment %}}</li>
   {% endfor %}
</ul>

{% macro render_comment(comment) %}
   <li>{{ comment }}</li>
{% endmacro %}

<ul>
   {% for comment in comments %}
      <li>{{% render_comment(comment) %}}</li>
   {% endfor %}
</ul>

```
