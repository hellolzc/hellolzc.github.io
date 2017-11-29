[root@VM_68_188_centos ~]# cd /etc/nginx/conf.d/
[root@VM_68_188_centos conf.d]# ls
defaut.conf.bak  ssl.conf  virtual.conf  wordpress.conf
[root@VM_68_188_centos conf.d]# cat defaut.conf.bak 
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

[root@VM_68_188_centos conf.d]# ls
defaut.conf.bak  ssl.conf  virtual.conf  wordpress.conf
[root@VM_68_188_centos conf.d]# cat ssl.conf 
#
# HTTPS server configuration
#

#server {
#    listen       443 ssl http2 default_server;
#    listen       [::]:443 ssl;
#    server_name  _;
#    root         /usr/share/nginx/html;
#
#    ssl_certificate cert.pem;
#    ssl_certificate_key cert.key;
#    ssl_session_cache shared:SSL:1m;
#    ssl_session_timeout  10m;
#    ssl_ciphers HIGH:!aNULL:!MD5;
#    ssl_prefer_server_ciphers on;
#
#    # Load configuration files for the default server block.
#    include /etc/nginx/default.d/*.conf;
#
#    location / {
#    }
#
#    error_page 404 /404.html;
#        location = /40x.html {
#    }
#
#    error_page 500 502 503 504 /50x.html;
#        location = /50x.html {
#    }
#}

server {
        listen 443;
        server_name hellolzc.cn; # 改为绑定证书的域名

        # wordpress
        root /usr/share/wordpress;

        # https
        ssl on;
        ssl_certificate 1_hellolzc.cn_bundle.crt; # 改为自己申请得到的 crt 文件的名称
        ssl_certificate_key 2_hellolzc.cn.key; # 改为自己申请得到的 key 文件的名称
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;

        #location / {
        #    root   /usr/share/nginx/html; #站点目录
        #    index  index.html index.htm;
        #}
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
[root@VM_68_188_centos conf.d]# cat wordpress.conf 
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
}[root@VM_68_188_centos conf.d]# cat virtual.conf 
#
# A virtual host using mix of IP-, name-, and port-based configuration
#

#server {
#    listen       8000;
#    listen       somename:8080;
#    server_name  somename  alias  another.alias;

#    location / {
#        root   html;
#        index  index.html index.htm;
#    }
#}

[root@VM_68_188_centos conf.d]# 

