## 让我们一览 Django 全貌
- urls.py
> 网址入口

- views.py
> 处理用户发出的请求

- models.py
> 与数据库操作相关

- forms.py
> 表单，用户在浏览器上输入数据提交，对数据的验证工作以及输入框的生成等工作

- templates文件夹
> views.py中函数渲染 templates的Html模板，得到动态内容的网页，

- admin.py
> 后台

- settings.py
> Django的设置

```python
pip install Django==1.8.16 或者 pip install Django==1.11.8
```

### 新建一个 django project
```python
django-admin.py startproject project_name
```

### 新建 app
> 要先进入项目目录下，cd project_name 然后执行下面的命令
```python
python manage.py startapp app_name
```

### 创建数据库表 或 更改数据库表或字段
> 这种方法可以在SQL等数据库中创建与models.py代码对应的表，不需要自己手动执行SQL

```python
Django 1.7.1及以上 用以下命令
# 1. 创建更改的文件
python manage.py makemigrations
# 2. 将生成的py文件应用到数据库
python manage.py migrate


旧版本的Django 1.6及以下用
python manage.py syncdb
```

### 使用开发服务器
> 开发服务器，即开发时使用，一般修改代码后会自动重启，方便调试和开发
```python
python manage.py runserver

# 当提示端口被占用的时候，可以用其它端口：
python manage.py runserver 8001
python manage.py runserver 9999
（当然也可以kill掉占用端口的进程，具体后面有讲，此处想知道的同学可查下 lsof 命令用法）

# 监听机器所有可用 ip （电脑可能有多个内网ip或多个外网ip）
python manage.py runserver 0.0.0.0:8000
# 如果是外网或者局域网电脑上可以用其它电脑查看开发服务器
# 访问对应的 ip加端口，比如 http://172.16.20.2:8000
```

### 清空数据库
```python
python manage.py flush
```

### 创建超级管理员
```python
python manage.py createsuperuser

# 按照提示输入用户名和对应的密码就好了邮箱可以留空，用户名和密码必填

# 修改 用户密码可以用：
python manage.py changepassword username
```

### 导出数据 导入数据
```python
python manage.py dumpdata appname > appname.json
python manage.py loaddata appname.json
```

### Django 项目环境终端
```python
python manage.py shell
```

### 数据库命令行
```python
python manage.py dbshell
```

## Django 视图与网址
> Django中网址是写在 urls.py 文件中，用正则表达式对应 views.py 中的一个函数(或者generic类)

### 首先，新建一个项目(project), 名称为 mysite
```python
django-admin startproject mysite

mysite
├── manage.py
└── mysite
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py
```

### 新建一个应用(app), 名称叫 learn
```python
python manage.py startapp learn # learn 是一个app的名称

learn/
├── __init__.py
├── admin.py
├── models.py
├── tests.py
└── views.py
# 把我们新定义的app加到settings.py中的INSTALL_APPS中,新建的 app 如果不加到 INSTALL_APPS 中的话, django 就不能自动找到app中的模板文件(app-name/templates/下的文件)和静态文件(app-name/static/中的文件)
# mysite/mysite/settings.py

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'learn',
)
```
#### 定义视图函数（访问页面时的内容）
> 们在learn这个目录中,把views.py打开
```python
# coding:utf-8
# HttpResponse，它是用来向网页返回内容的，就像Python中的 print 一样，只不过 HttpResponse 是把内容显示到网页上。

from django.http import HttpResponse

# 我们定义了一个index()函数，第一个参数必须是 request，与网页发来的请求有关，request 变量里面包含get或post的内容，用户浏览器，系统等信息在里面
def index(request):
    return HttpResponse(u"欢迎光临 自强学堂!")
```

#### 定义视图函数相关的URL(网址)
>  mysite/mysite/urls.py
- Django 1.7.x
```python
from django.conf.urls import patterns, include, url
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'learn.views.index'),  # new
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
```

- Django 1.8.x - Django 2.0
```python
from django.conf.urls import url
from django.contrib import admin
from learn import views as learn_views  # new

urlpatterns = [
    url(r'^$', learn_views.index),  # new
    url(r'^admin/', admin.site.urls),
]
```

- Django 2.0 版本
```python
from django.contrib import admin
from django.urls import path
from learn import views as learn_views  # new

urlpatterns = [
    path('', learn_views.index),  # new
    path('admin/', admin.site.urls),
]
```

## Django 视图与网址进阶
### 在网页上做加减法
#### /add/?a=4&b=5 这样GET方法进行
```python
django-admin.py startproject zqxt_views
cd zqxt_views
python manage.py startapp calc
```

> calc/views.py
```python
from django.shortcuts import render
from django.http import HttpResponse

def add(request):
   a = request.GET['a']
   b = request.GET['b']
   c = int(a)+int(b)
   return HttpResponse(str(c))
```
> zqxt_views/urls.py
> 参考上述方法
- Django 1.8.x
```python
urlpatterns = [
    url(r'^add/$', calc_views.add, name='add'),  # 注意修改了这一行
    url(r'^admin/', admin.site.urls),
]
```

- Django 2.0
```python
urlpatterns = [
    path('add/', calc_views.add, name='add'),  # new
    path('admin/', admin.site.urls),
]
```

> 访问 http://127.0.0.1:8002/add/?a=4&b=5

#### 采用 /add/3/4/ 这样的网址的方式
> calc/views.py
```python
def add2(request, a, b):
    c = int(a) + int(b)
    return HttpResponse(str(c))
```

> zqxt_views/urls.py
> name 可以用于在 templates, models, views ……中得到对应的网址，相当于“给网址取了个名字”，只要这个名字不变，网址变了也能通过名字获取到
- Django 1.7.x
```python
url(r'^add/(\d+)/(\d+)/$', 'calc.views.add2', name='add2')
```
- Django 1.8.x － Django 1.11.x
```python
url(r'^add/(\d+)/(\d+)/$', calc.views.add2, name='add2')
```

- Django 2.0 及以上
```python
path('add/<int:a>/<int:b>/', calc_views.add2, name='add2')
```

## Django URL name详解
