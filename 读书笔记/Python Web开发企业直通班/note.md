## 【第54讲】1-django的介绍和安装_rec.mkv
> 将script脚本添加到path
> 将 site-package 添加到path中

## 【第55讲】2-创建一个网站_rec.mkv
```python
# 创建一个项目
python django-admin.py startproject projectname
# 创建一个应用
python django-admin.py startproject appname
# 启动一个项目
python manage.py startapp
```
- settings.py
```python
LANGUAGE_CODE = 'zh-hans'

TIME_ZONE = 'Asia/Shanghai'
```

- urls.py
```python
urlpatterns = [
    path('admin/', admin.site.urls),
    # 在输入的地址中包含 blog/index 就会去访问 blog.views.index 函数
    path('blog/index', 'blog.views.index'),
]
```

- blog.views
```python
from django.http import HttpResponse
def index(request):
    return HttpResponse("<h1>Hello world</h1>")

# blog目录下的 template 目录下的内容
from django.template import loader, Context
def index1(request):
    # 获取模板
    t = loader.get_template("index.html")
    # 传给模板的数据
    c = Context({})
    # 返回实际的的内容
    return HttpResponse(t.render(c))
```

## 【第56讲】3-模板变量_rec
