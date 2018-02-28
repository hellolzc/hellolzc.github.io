---
layout: post
title: 安装ubuntu之后要做的事
date: 2018-02-10 15:23:24 +08:00
categories: linux
tags: linux
---

<!---
安装ubuntu之后要做的事
--->

参考文章： https://ifhw.github.io/2016/01/20/ubuntu-notes/index.html

经常需要在多个电脑之前切换，每次都要设置一下，自己记录备忘，也供读者参考。

## 换源
在 “系统设置->软件和更新->ubuntu软件” 中修改，
如果是国内教育网用户，推荐使用清华的源`mirrors.tuna.tsinghua.edu.cn` 或中科大的源 `mirrors.ustc.edu.cn`。
如果是非教育网用户， 也可以使用阿里的源，听说速度也不错。

## 修改grub引导
grub引导程序默认等待10秒，如果想要加快开机速度，可以修改grub配置。

grub的配置文件在 `/boot/grub/grub.cfg`,但该文件实际上是根据 `/etc/default/grub` 的配置自动生成的。

```bash
sudo vim /etc/default/grub
```

注释掉 `GRUB_HIDDEN_TIMEOUT=0`， 修改 `GRUB_TIMEOUT=3`， 这里的3指的是等待3秒的意思。

你还可以修改默认启动项，其中的`GRUB_DEFAULT=0`一行就是设置的默认启动项了。GRUB启动项是按照启动菜单依次使用数字进行索引的，起始数字为0。
结合开机时出现的系统启动菜单，我的Windows的启动项在第5项，因此如果想让windows成为默认启动项，这个参数就需要修改为4。

重新生成grub的配置文件：

```bash
sudo update-grub
```

## 安装sogou拼音
搜狗拼音的linux版支持不错。不过随着ubuntu系统升级，现在自带的“拼音”输入法也挺好用，所以这一步可以跳过。

从官网 http://pinyin.sogou.com/linux/?r=pinyin 下载安装包。
```bash
sudo apkg -i sogoupinyin_2.0.0.0072_amd64.deb
```

然后再系统语言支持里，输入法选择fcitx。
接着在Fcitx Configuration的Input Method里添加Sogou Pinyin。
Ctrl+Space切换输入法

## 将用户目录的文件夹改回英文

如果在ubuntu安装时，语言选择的是中文,那么自动生成的目录也成了中文,导致命令行操作非常麻烦。解决方法如下：
打开终端输入
```bash
export LANG=en_US
xdg-user-dirs-gtk-update
export LANG=zh-CN
```
在弹出的窗口中选择将文件夹改成英文,在下次启动时选择不改成中文并且不再提示即可。

为了避免上述麻烦，建议安装的时候选择英文，装好了之后再安装中文语言包。
在“设置->语言支持”中添加语言包。
注意两点：
1. 切换语言的时候，把图形界面的语言改回中文，不要“应用到系统层面”，因为ubuntu在文字界面下中文支持不好，要安装额外的包才行。
2. 重新登录时如果提醒修改home目录下的文件夹名称，建议保留英文名称。

## 添加文件夹右键打开终端
Ubuntu 16.04 自带了，可忽略这步

```bash
sudo apt install nautilus-open-terminal
```

重新加载文件管理器

```bash
nautilus -q
```

或者注销再登陆即可使用。

## 设置系统时间为本地时间(单操作系统可忽略)
linux系统向来将BIOS时间视为GMT标准时间,于是将当前BIOS时间+当前时区的时差作为当前系统时间,而windows则直接使用BIOS时间作为当前系统时间,
且两个系统都会在关机时将时间回写到BIOS上,这就造成了两个系统之间永远都有8小时(以北京时间计算)的时差。

随便修改哪个系统都可以解决这个问题,这里只说linux解决方案, 在16.04以前的版本中,可以修改 `/etc/default/rcS` 将里面的 `UTC=yes` 改成 `no` 即可。

而ubuntu16.04无法再通过该文件配置,现在应该运行如下命令
```bash
sudo timedatectl set-local-rtc 1
```

## 修改hosts
修改hosts后重启网络生效
```bash
sudo /etc/init.d/netwroking restart
```

## 安装字体

将windows下的一些字体搬运至linux下，字体可以在window目录下搜索得到。
可以用字体查看器安装，也可以直接将目录移到/usr/share/fonts/目录下

### Courier
    COURBD.TTF
    COURBI.TTF
    COURI.TTF
    COUR.TTF

### 微软雅黑
    msyhbd.ttc
    MSYHBD.TTF
    msyh.ttc
    MSYH.TTF

### Monotype Corsiva
    MTCORSVA.TTF
    monotypesorts.ttf

### 仿宋 黑体 楷体 宋体
    SIMFANG.TTF
    SIMHEI.TTF
    SIMKAI.TTF
    simsun.ttc

### Times New Roman
    TIMESBD.TTF
    TIMESBI.TTF
    TIMESI.TTF
    TIMES.TTF

### 符号字体
    Mt Extra Tiger.ttf
    mtextra_01.ttf
    Symbol Tiger Expert.ttf
    symbol.ttf
    Symbol Tiger.ttf
    wingding.ttf
    WINGDNG2.TTF
    WINGDNG3.TTF

### 一些写代码专用字体
    MONACO.TTF
    consolas-powerline-vim

## 安装其他软件
详情见下一篇文章《ubuntu下推荐的软件》
