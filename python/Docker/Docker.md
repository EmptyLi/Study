> 启动 httpd 容器，并将容器的 80 端口映射到 host 的 80 端口
> 在浏览器中输入 http://[your ubuntu host IP]
```bash
[root@localhost Documents]# docker run -d -p 80:80 httpd
Unable to find image 'httpd:latest' locally
Trying to pull repository docker.io/library/httpd ...
latest: Pulling from docker.io/library/httpd
f2b6b4884fc8: Pull complete
b58fe2a5c9f1: Pull complete
e797fea70c45: Pull complete
6c7b4723e810: Pull complete
02074013c987: Pull complete
4ad329af1f9e: Pull complete
0cc56b739fe0: Pull complete
Digest: sha256:b54c05d62f0af6759c0a9b53a9f124ea2ca7a631dd7b5730bca96a2245a34f9d
Status: Downloaded newer image for docker.io/httpd:latest
d25318e3fa1ce167a4bb059206a7e730bc10929906def21b3b6903cb9f1a5938
```

> docker images 可以查看到 httpd 已经下载到本地。
```bash
[root@localhost ~]# docker run -d -p 80:80 httpd
255f154c74d6980abadd3935dcd10d482d1cc0f5dbddbd660981efc7217c9e59
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/httpd     latest              805130e51ae9        3 weeks ago         178 MB
```


> docker ps 或者 docker container ls 显示容器正在运行。
```bash
[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
255f154c74d6        httpd               "httpd-foreground"   5 minutes ago       Up 5 minutes        0.0.0.0:80->80/tcp   thirsty_fermi
[root@localhost ~]# docker container ls
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
255f154c74d6        httpd               "httpd-foreground"   5 minutes ago       Up 5 minutes        0.0.0.0:80->80/tcp   thirsty_fermi
```
