---
layout: post
title: 搭建 WordPress 个人博客
date: 2017-08-15 11:11:11 +08:00
categories: linux
tags: linux wordpress

---
<!---
# 搭建 WordPress 个人博客
-->


为了搭梯子，买了一个vps，建好后顺便再建一个博客 ：）

WordPress解决方案功能强大，适合部署在个人主机上。在此将我的折腾过程记录下来，为了将来参考，也提供给同志们参考。

说明：
* 本博客中使用的操作系统是centos 6.8，如果你使用的是其他版本，请自行替换修改系统服务的相关命令。
在centos 7中启动服务命令是`systemctl start [服务].service`，设置开机启动的命令是`systemctl enable [服务].service`。
在centos 7中安装MySQL的方法请自行查阅相关资料。
* 博文假定你已经对Linux比较熟悉了，会连接服务器并且会使用vi等编辑器

## 1.准备 LNMP 环境
LNMP代表的就是：Linux系统下Nginx+MySQL+PHP这种网站服务器架构。
Linux是一类Unix计算机操作系统的统称，是目前最流行的免费操作系统。代表版本有：debian、centos、ubuntu、fedora等。
Nginx是一个高性能的HTTP和反向代理服务器，也是一个IMAP/POP3/SMTP代理服务器。
作为 Web 服务器：Ngin相比 Apache，Nginx 使用更少的资源，支持更多的并发连接，体现更高的效率。
Mysql是一个小型关系型数据库管理系统。
PHP是一种在服务器端执行的嵌入HTML文档的脚本语言。
这四种软件均为免费开源软件，组合到一起，成为一个免费、高效、扩展性强的网站服务系统。

本博客中使用的操作系统是centos 6.8，如果你使用的是centos 7,建议使用lnmp一键安装包安装，方便快捷。
如果不用一键安装包，在centos 7中安装MySQL比较麻烦。如果使用一键安装包，请跳到“使用lnmp一键安装包”一节。

### 安装 Nginx
使用 yum 安装 Nginx：
```shell
yum install nginx -y
```
修改 /etc/nginx/conf.d/default.conf，去除对 IPv6 地址的监听（centos 6 不支持IPv6）
，可参考下面的示例：
default.conf
```
#
# The default server
#

server {
    listen       80 default_server;
    # listen       [::]:80 default_server;
    server_name  _;
    root         /usr/share/nginx/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }

}
```


修改完成后，启动 Nginx：
```shell
nginx
```
此时，可访问实验机器外网 HTTP 服务（http://你申请的IP）来确认是否已经安装成功。
将 Nginx 设置为开机自动启动：
```shell
chkconfig nginx on
```
### 安装 MySQL
使用 yum 安装 MySQL：
```shell
yum install mysql-server -y
```
安装完成后，启动 MySQL 服务：
```shell
service mysqld restart
```
设置 MySQL 账户 root 密码：
```shell
/usr/bin/mysqladmin -u root password 'MyPas$word4Word_Press'
```
将 MySQL 设置为开机自动启动：
```
chkconfig mysqld on
```
### 安装 PHP
使用 yum 安装 PHP：
```
yum install php-fpm php-mysql -y
```

安装之后，启动 PHP-FPM 进程：
```
service php-fpm start
```
启动之后，可以使用下面的命令查看 PHP-FPM 进程监听哪个端口
```
netstat -nlpt | grep php-fpm
```
把 PHP-FPM 也设置成开机自动启动：
```
chkconfig php-fpm on
```

### 使用lnmp一键安装包
在centos 7中安装MySQL比较麻烦，如果你使用的是centos 7,建议使用lnmp一键安装包安装，方便快捷。
如果不用一键安装包，。

获取lnmp一键安装包链接
[lnpm官网链接](https://lnmp.org/download.html)

找到下载页面选择最新的复制其链接。
写该博客时LNMP最新稳定版为1.4
```
最新稳定版本:

LNMP 1.4

下载版：(不含源码安装包文件，仅有安装脚本及配置文件)
http://soft.vpser.net/lnmp/lnmp1.4.tar.gz  (134KB)
MD5: c20e6060e100a768c03c3c2a9012adae
```
下载安装
```
# 下载，后边的路径直接粘贴就好。
wget http://soft.vpser.net/lnmp/lnmp1.4.tar.gz
# 解压
tar -zxvf lnmp1.4.tar.gz
# 进入lnmp目录
cd lnmp1.4
# 执行install.sh进行安装
./install.sh
```
LNMP一键安装包会帮你把开机自启动都设置好，所以就不用自己一个一个设置了。


## 2.安装并配置 WordPress

### 安装 WordPress
配置好 LNMP 环境后，开始安装 WordPress。

可以直接从[官网](https://cn.wordpress.org/)上下载,它只是一个文件夹而已。

你也可以使用 yum 来安装 WordPress：
```
yum install wordpress -y
```
安装完成后，就可以在 /usr/share/wordpress 看到 WordPress 的源代码了。

### 配置数据库
进入 MySQL：
```
mysql -uroot --password='MyPas$word4Word_Press'
```
为 WordPress 创建一个数据库：
```SQL
CREATE DATABASE wordpress;
```
WordPress将所有的博客和配置数据都放在这个数据库中，当升级WordPress时，只要这个数据库不变，博客数据就不会丢失。

MySQL 部分设置完了，退出 MySQL 环境：
```
exit
```
把上述的 DB 配置同步到 WordPress 的配置文件中，可参考下面的配置：
wp-config.php
```php
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'MyPas$word4Word_Press');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * See http://make.wordpress.org/core/2013/10/25/the-definitive-guide-to-disabling-auto-updates-in-wordpress-3-7
 */

/* Disable all file change, as RPM base installation are read-only */
define('DISALLOW_FILE_MODS', true);

/* Disable automatic updater, in case you want to allow
   above FILE_MODS for plugins, themes, ... */
define('AUTOMATIC_UPDATER_DISABLED', true);

/* Core update is always disabled, WP_AUTO_UPDATE_CORE value is ignore */

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', '/usr/share/wordpress');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
```
### 配置 Nginx
WordPress 已经安装完毕，我们配置 Nginx 把请求转发给 PHP-FPM 来处理
首先，重命名默认的配置文件：
```shell
cd /etc/nginx/conf.d/
mv default.conf default.conf.bak
```
在 /etc/nginx/conf.d 创建 wordpress.conf 配置，参考下面的内容：
wordpress.conf
```
server {
    listen 80;
    root /usr/share/wordpress;
    location / {
        index index.php index.html index.htm;
        try_files $uri $uri/ /index.php index.php;
    }
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ .php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
配置后，通知 Nginx 进程重新加载：
```
nginx -s reload
```

## 3.准备域名和解析

### 域名注册
如果您还没有域名，可以找你的vps托管商购买，在这里用的是腾讯云。
你也可以找godaddy等域名商购买。

### 域名解析
域名购买完成后, 需要将域名解析到vps主机上。
到前往你购买的域名控制台添加解析记录。
域名设置解析后需要过一段时间才会生效，通过 ping 命令检查域名是否生效，如：
```
ping www.yourdomain.com
```

如果 ping 命令返回的信息中含有你设置的解析的 IP 地址，说明解析成功。

## 大功告成！
恭喜，你的 WordPress 博客已经部署完成，您可以通过浏览器访问博客查看效果。

通过IP地址查看：
博客访问地址：http://yourip/wp-admin/install.php

通过域名查看：
博客访问地址：http://www.yourdomain.com/wp-admin/install.php，其中替换 www.yourdomain.com 为之前申请的域名。

管理员页面： http://www.yourdomain.com/wp-admin

## 后记
接下来你要写自己的博客了，一般而言要考虑下面几个问题：

### 主题
有很多主题，官方的比较简单，你可以百度找找。

### 插件
我使用了下面三个插件

* Akismet Anti-Spam ： 预装的，保护你免受垃圾邮件侵扰
* Hello Dolly ：预装的，提供点乐子 XD
* WP Editor.md ： 或许这是一个WordPress中最好，最完美的Markdown编辑器。但是你喜欢Markdown，为什么不试试jekyll或Hexo解决方案呢 XD

### 图片存储
刚搭建的博客，你可以先把图片放在自己的主机上，如果文章中图片较多的话，主机空间可能会限制图片存储。
寻找一个稳定易用的图床，方便图片的使用和存储，这里推荐一个优秀的国外免费图床：photobucket。

### SSL证书
虽然说你的博客内容没什么好加密的，但你进入控制台的时候最好还是使用https加密。你可以找vps托管商申请一个SSL证书，安装就不详述了。

## 参考资料
* 腾讯云开发者实验室 https://www.qcloud.com/developer/labs/
* 静候那一米阳光 - 简书 http://www.jianshu.com/p/56750622cac9
* 知乎 https://www.zhihu.com/question/19594033

