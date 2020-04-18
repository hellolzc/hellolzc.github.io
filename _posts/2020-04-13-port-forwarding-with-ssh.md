---
layout: post
title: 妙用SSH端口转发
date: 2020-04-13 22:00:00 +08:00
categories: network
tags: network ssh
---

## SSH 端口转发简介

参考这篇文章：[实战 SSH 端口转发](https://www.ibm.com/developerworks/cn/linux/l-cn-sshforward/index.html)

&emsp;&emsp;我们常用 SSH 连接远程服务器，SSH 会自动加密和解密所有 SSH 客户端与服务端之间的网络数据。但是，SSH 还同时提供了一个非常有用的功能，这就是端口转发。它能够将其他 TCP 端口的网络数据通过 SSH 链接来转发，并且自动提供了相应的加密及解密服务。


### 本地转发


本地转发的命令格式是：
```bash
ssh -L <local port>:<remote host>:<remote port> <SSH hostname>
```

参数解释：

    <local port> 本地端口，一般是选用一个 1024-65535 之间的并且尚未使用的端口号。
    <remote host>:<remote port> 要转发的服务器地址和端口号
    <SSH hostname>   ssh服务器的地址

&emsp;&emsp;让我们来看一个涉及到四台机器 (A,B,C,D) 的例子。

![本地端口转发](/assets/2020-04/ssh-1-1.jpg)

&emsp;&emsp;机器（A）和 (C) 在防火墙外面， (B)和(D)在防火墙里面，（A）和 (C)可以直接连接，(B)和(D)可以直接连接。机器(C)可以访问(D)，反向则不能。

&emsp;&emsp;注: LDAP（Light Directory Access Portocol）是一个轻量级目录访问协议，这里只是拿它举个例子。


&emsp;&emsp;在 SSH Client(C) 执行下列命令来建立 SSH 连接以及端口转发：

```bash
$ ssh -g -L 7001:<B>:389 <D>
```

&emsp;&emsp;然后在我们的应用客户端（A）上配置连接机器（C）的 7001 端口即可访问机器(B)的 389 端口。
注意我们在命令中指定了“ -g ”参数以保证机器（A）能够使用机器（C）建立的本地端口转发。而另一个值得注意的地方是，在上述连接中，（A）<-> (C) 以及 (B)<->(D) 之间的连接并不是安全连接，它们之间没有经过 SSH 的加密及解密。如果他们之间的网络并不是值得信赖的网络连接，我们就需要谨慎使用这种连接方式了。

&emsp;&emsp;在上图中, (A)和(C)可以是同一台机器，(B)和(D)可以是同一台机器。
(A)和(C)是同一台机器时，不需要“ -g ”参数
(B)和(D)是同一台机器时，(B)的地址可以填localhost或127.0.0.1。
(A)和(C)不是同一台机器时，且（C）是Windows时，要打开防火墙对应端口, (A)才能访问。



### 远程转发


&emsp;&emsp;首先，SSH 端口转发自然需要 SSH 连接，而 SSH 连接是有方向的，从 SSH Client 到 SSH Server 。而我们的应用也是有方向的，比如需要连接 LDAP Server 时，LDAP Server 自然就是 Server 端，我们应用连接的方向也是从应用的 Client 端连接到应用的 Server 端。如果这两个连接的方向一致，那我们就说它是本地转发。而如果两个方向不一致，我们就说它是远程转发。

&emsp;&emsp;这次假设由于网络或防火墙的原因我们不能用 SSH 直接从 LdapClientHost 连接到 LDAP 服务器（LdapServertHost），但是反向连接却是被允许的。那此时我们的选择自然就是远程端口转发了。

&emsp;&emsp;它的命令格式是：

```bash
ssh -R <local port>:<remote host>:<remote port> <SSH hostname>
```

&emsp;&emsp;例如在 LDAP 服务器（LdapServertHost）端执行如下命令：
```
$ ssh -R 7001:localhost:389 LdapClientHost
```

![远程端口转发](/assets/2020-04/ssh-1-2.jpg)


&emsp;&emsp;和本地端口转发相比，这次的图里，首先只有两台计算机，此外 SSH Server 和 SSH Client 的位置对调了一下，但是数据流依然是一样的。我们在 LdapClientHost 上的应用将数据发送到本机的 7001 端口上，而本机的 SSH Server 会将 7001 端口收到的数据加密并转发到 LdapServertHost 的 SSH Client 上。 SSH Client 会解密收到的数据并将之转发到监听的 LDAP 389 端口上，最后再将从 LDAP 返回的数据原路返回以完成整个流程。


## 安装OpenSSH客户端


&emsp;&emsp;本地计算机可以使用Win10自带的ssh客户端。
安装方式：Windows设置 -> 应用 -> 应用和功能 -> 可选功能 检查OpenSSH客户端是否安装，没有安装的话点“添加功能”安装。

![example-3](/assets/2020-04/ssh-3.png)

&emsp;&emsp;非Win10的Windows用户可以使用Git for windows中提供的openssh工具，
Linux用户系统已经自带了OpenSSH，不需要额外安装。



## 局域网实际使用举例


&emsp;&emsp;首先，你需要有一台ssh server机器，位于局域网的NAT之内，而且它可以被外界访问。
你可以和网络管理员要一个。也可以自己买一个VPS，使用[frp](https://github.com/fatedier/frp)将局域网内的ssh服务端口开放到外网。

&emsp;&emsp;这里假定你已经使用了 frp 将**局域网内的ssh服务端口**映射到了**公网机器(IP假设为`123.123.123.123`)**上，端口为`6001`
而且你在**局域网内的ssh服务器(IP假设为`192.168.0.123`)**上有一个账户名为`user`

### 例一：转发windows服务器的远程桌面


&emsp;&emsp;在本地电脑上打开PowerShell，输入如下命令（参数需要自己修改，参见上一节的解释）：
```
ssh -L 10080:<内网Windows服务器IP>:3389 user@123.123.123.123 -p 6001
```

&emsp;&emsp;上面这条命令使用帐号 `user` 登录了 `123.123.123.123` 的 `6001` 端口对应的服务器(`192.168.0.123`)，并在该服务器上建立一个ssh转发，将本地计算机(`127.0.0.1`，`localhost`)的`10080`端口映射到了 `<内网Windows服务器IP>` 的 `3389` 端口。
回车后，提示输入密码，输入账号 `user` 在`192.168.0.123`服务器密码。
登录后不要关闭Powershell窗口，否则转发会中断。

&emsp;&emsp;之后便可以用本地地址访问windows服务器的远程桌面。

![example-2-1](/assets/2020-04/ssh-2-1.png)

&emsp;&emsp;为了节约带宽并提高流畅度，可以把桌面背景改成纯色，可以把颜色深度调低，还可以把显示配置里的分辨率调小，一般使用1600*900分辨率。
PS：如果是高分屏觉得此分辨率看不清楚可以使用远程桌面自带的缩放功能。在标题栏上点右键即可。


&emsp;&emsp;同理，如果局域网的个人电脑也开启了远程桌面功能，也可以用这种办法访问。
RDP协议优化是是很好的，这种办法 1 Mbps 的带宽就可以获得比较流畅的体验


### 例二：转发目标服务器的web服务

&emsp;&emsp;tensorboard 和 jupyter notebook 使用的是 http 协议，可以通过端口转发来访问。

&emsp;&emsp;打开Powershell，输入如下命令
```bash
ssh -L 28186:localhost:28888 user@123.123.123.123 -p 6001
```

&emsp;&emsp;上面这条命令使用帐号 `user` 登录了 `123.123.123.123` 的 `6001` 端口对应的服务器(`192.168.0.123`)，并在该服务器上建立一个ssh转发，将本地计算机的`28186`端口映射到了`192.168.0.123` 的 `28888` 端口。

![example-2-2](/assets/2020-04/ssh-2-2.png)

&emsp;&emsp;之后再浏览器中输入`127.0.0.1:28186`便可以直接访问该端口的网页。


### 例三：让服务器使用本地计算机的代理

&emsp;&emsp;问：能不能让服务器使用本地计算机的网络呢？比如说，可以让`git clone`可以走我的PC上的代理？

&emsp;&emsp;答：可以，
这里假设本地PC的`8080`端口提供了代理服务, 目标是让服务器 A 上的Git可以使用代理，假定你可以直接ssh登录服务器 A,
登录账户名为`hello`。
使用命令
```bash
ssh -R 10800:localhost:8080 hello@<A 的IP>
```
建立远程转发，就将本地`8080`端口的代理转发到ssh服务器 A 上的`10800`端口了。

&emsp;&emsp;测试代理设置是否有效：在服务器上执行

```bash
ss -lntpd | grep :10800  # 查看端口是否启用

curl www.google.com --socks5 127.0.0.1:10800  # 测试访问google
```

&emsp;&emsp;Git使用代理参考[我之前的博客](/2017/09/git-notes)。
成功之后想干啥就可以干啥啦 XD


### 其他问题

&emsp;&emsp;问：那能不能直接转发服务器的Samba文件共享服务呢？

&emsp;&emsp;答：不可以，Windows不支持使用自定义的端口访问Samba服务器。
详见 [windows 访问 samba 如何指定端口？ - V2EX](https://www.v2ex.com/t/541663)


&emsp;&emsp;问：可以不借助公网服务器建立转发吗？

&emsp;&emsp;答：可以，可以借助Teamviewer VPN功能，使用实验室电脑做跳板。
参考CSDN博客(ccproxy可以从官网上下载，免费版够用)：
[teamview+ccproxy实现远程局域网本地访问- CSDN博客](https://blog.csdn.net/sky835202/article/details/80180279)


