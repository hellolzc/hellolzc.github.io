---
layout: post
title: ubuntu上搭建dokuwiki
date: 2020-04-11 22:52:00 +08:00
categories: linux
tags: linux
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->



环境：ubuntu18.04

看了很多教程，最后发现官方文档最靠谱
[DokuWiki Installation](https://www.dokuwiki.org/zh:install)

官方文档配置更全也更难懂，我主要还参考了文章
[Build your own wiki on Ubuntu with DokuWiki by ThisHosting.Rocks](https://thishosting.rocks/build-your-own-wiki-on-ubuntu-with-dokuwiki/)
及其翻译
[在 Ubuntu 上使用 DokuWiki 构建你自己的 wiki 作者:thishostrocks.com 译者：LCTT geekp](https://linux.cn/article-8178-1.html)

原文用的是Apache，由于我服务器上已经安装了nginx，故这里换成nginx。过程中还参考了
[Ubuntu安装DokuWiki（Nginx）- 八风不动](https://my.oschina.net/bfbd/blog/885280)
和
[CommentsLinux(Ubuntu)环境安装配置Nginx+Dokuwiki - 咖啡兔](http://www.kafeitu.me/2012/02/03/ubuntu-nginx-install-dokuwiki.html)

如果没有这方面经验建议先在相同环境的虚拟机上尝试，之后再部署到服务器上。


## 准备环境

开始之前，你应该升级你的系统

```bash
sudo apt-get update && sudo apt-get upgrade
```

首先安装ngnix，安装成功后访问你的服务器网址，看看能否访问到nginx默认页面。


安装 PHP。在本教程中，我们使用 PHP7。
```bash
apt-get install php php-fpm php-cgi php-cli php-curl php-json php-gd php-xml  

php-mcrypt
php-apcu
```

如果上面方法不行，尝试安装其他源的
```bash
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install php7.1 php7.1-fpm
php -v
```

配置wiki网站文件存储位置

```bash
cd /etc/nginx/sites-available
cp default wiki vi wiki
```
wiki文件内容
```
server {
        listen 80;
        server_name wiki.yourdomain.com;

        root /prj/wiki/dokuwiki;
        index index.php index.html;

        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
}
```

## 安装 DokuWiki

运行下面的命令来下载最新（稳定）的 DokuWiki：
```
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
```

解压 .tgz 文件：
```
tar xvf dokuwiki-stable.tgz
```
更改文件/文件夹权限（只用后面这句好像也行）：
```
chown www-data:www-data -R /var/www/thrwiki
chmod -R 707 /var/www/thrwiki
```


为你的 DokuWiki 创建一个 .conf 文件（我们把它命名为 thrwiki.conf，但是你可以把它命名成任何你想要的），并用你喜欢的文本编辑器打开。

```
<VirtualHost yourServerIP:80>
ServerAdmin wikiadmin@thishosting.rocks
DocumentRoot /var/www/thrwiki/
ServerName wiki.thishosting.rocks
ServerAlias www.wiki.thishosting.rocks
<Directory /var/www/thrwiki/>
    Options FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>
ErrorLog /var/log/apache2/wiki.thishosting.rocks-error_log
CustomLog /var/log/apache2/wiki.thishosting.rocks-access_log common
</VirtualHost>
```


编辑与你服务器相关的行。将 wikiadmin@thishosting.rocks、wiki.thishosting.rocks 替换成你自己的数据




应用新的配置文件并重启Nginx 

```bash
cd /etc/nginx/sites-enabled
ln -s ../sites-available/wiki wiki

nginx -s reload
```

其他一些可能会用的命令：
```
sudo /etc/init.d/php7.1-fpm stop
sudo /etc/init.d/nginx restart
```


现在已经配置完成了。现在你可以继续通过前端页面 http://wiki.thishosting.rocks/install.php 安装配置 DokuWiki 了。安装完成后，你可以用下面的命令删除 install.php：
```
rm -f /var/www/html/thrwiki/install.php
```


DokuWiki 用户手册 <https://www.dokuwiki.org/start?id=zh:manual>

