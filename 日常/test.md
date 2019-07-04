# 自动化部署脚本
## 基本信息
> Author：Rany

> Date: 20180417

> Python Version: 3.5

## 依赖软件
- Oracle客户端
- Git 客户端安装
> 参考 《Git安装文档.docx》

## 依赖包清单
- xlrd
- cx_Oracle
- psycopg2
- configparser
- GitPython

```python
# 在线安装
pip install <包名> 或 pip install -r requirements.txt

# 安装本地安装包
pip install <目录>/<文件名> 或 pip install --use-wheel --no-index --find-links=wheelhouse/ <包名>
```


## 脚本特性
- 支持oracle、PGSQL
- 本地需根据每个项目，配置一个github本地目录

## 注意事项
1、更改配置文件的位置
cmb_autodeploy.py

```python
# 替换成配置文件的实际地址
config_file = 'E:/OWNCLOUD/4_master/2招商银行/数据库开发/债乎数据库增量发布文档v1.0-20180323.xlsx'

# 配置成获取脚本的目录
base_path='E://auto_deploy/'+github_repo+'/'+github_repo

# 数据库配置目录为
base_path='E://auto_deploy/'+github_repo+'/'+github_repo
```


## 注意事项
1、 存储过程、函数等对象，不能放在同一个文件中，要进行拆分一个对象一个文件，否则无法创建成功

2、 文件命名：部署文件个数超过10个，小于100个，用01表示1，如果超过100个，小于1000个用001表示1

3、 要重建存储过程、函数等对象，先删除再重建，分文件存放，且保证删除脚本要先于对象创建文件执行

4、rename不能指定schema名字，只能在当前schema

5、带有物化视图的基表不能rename


## 脚本分类
- 初始化对象
    > 每个执行语句块，用分号分隔，以sql结尾，必须是小写sql
- 备份
    > 每个执行语句块，用分号分隔，以sql结尾，必须是小写sql

- 创建对象（表、字段、视图、物化视图、索引、序列等）
    > 每个执行语句块，用分号分隔，以sql结尾，必须是小写sql

- 创建对象（存储过程、函数等）
    > 每一个对象，都是一个单独的脚本，以proc结尾 ，必须是小写proc

- 清理备份对象
    > 每个执行语句块，用分号分隔，以sql结尾，必须是小写sql

- 回滚
    > 每个执行语句块，用分号分隔，以sql结尾，必须是小写sql
