---
layout: post
title: Linux下压缩和解压缩命令总结
date: 2017-12-01 20:03:24 +08:00
categories: linux
tags: linux
---

相信不少人都曾经为在Linux下解压文件而头疼，笔者将解压文件的方法总结了一下，以备查阅。

## Linux解压缩命令总结

先上一张清单~

| 文件类型扩展名 | 解压命令                                                  | 压缩命令         |
| ---------    | --------------------------------------                    | ---------------------------  |
| .gz          | 法1：gunzip FileName.gz </br> 法2：gzip -d FileName.gz     | gzip FileName           |
| **.tar.gz**  | tar zxvf FileName.tar.gz                                  | tar zcvf FileName.tar.gz DirName |
| .bz2         | 法1：bzip2 -d FileName.bz2 </br> 法2：bunzip2 FileName.bz2 | bzip2 -z FileName            |
| .tar.bz2     | tar jxvf FileName.tar.bz2                                 | tar jcvf FileName.tar.bz2 DirName |
| .bz          | 法1：bzip2 -d FileName.bz </br> 法2：bunzip2 FileName.bz   | 未知                           |
| .tar.bz      | tar jxvf FileName.tar.bz                                  | 未知                           |
| .Z           | uncompress FileName.Z                                     | compress FileName              |
| .tar.Z       | tar Zxvf FileName.tar.Z                                   | tar Zcvf FileName.tar.Z DirName |
| .tgz         | tar zxvf FileName.tgz                                     | 未知                             |
| .tar.tgz     | tar zxvf FileName.tar.tgz                                 | tar zcvf FileName.tar.tgz FileName |
| **.zip**     | unzip FileName.zip                                        | zip FileName.zip DirName         |
| **.rar**     | rar a FileName.rar                                        | rar e FileName.rar              |

## tar命令

tar 是在 Linux 系统中经常使用的一个对文件进行压缩和解压缩的命令，许多开源项目的代码和文档用的都是这种压缩工具。

```bash
$ tar [-cxtzjvfpPN] 文件与目录 ....
```

### 参数：
```
-c ：建立一个压缩文件的参数指令(create 的意思)；
-x ：解开一个压缩文件的参数指令！
-t ：查看 tarfile 里面的文件！
特别注意，在参数的下达中， c/x/t 仅能存在一个！不可同时存在！
因为不可能同时压缩与解压缩。
-z ：是否同时具有 gzip 的属性？亦即是否需要用 gzip 压缩？
-j ：是否同时具有 bzip2 的属性？亦即是否需要用 bzip2 压缩？
-v ：压缩的过程中显示文件！这个常用，但不建议用在背景执行过程！
-f ：使用档名，请留意，在 f 之后要立即接档名喔！不要再加参数！
　　　例如使用『 tar -zcvfP tfile sfile』就是错误的写法，要写成
　　　『 tar -zcvPf tfile sfile』才对喔！
-p ：使用原文件的原来属性（属性不会依据使用者而变）
-P ：可以使用绝对路径来压缩！
-N ：比后面接的日期(yyyy/mm/dd)还要新的才会被打包进新建的文件中！
--exclude FILE：在压缩的过程中，不要将 FILE 打包！
```

### 范例：

* 范例一：将整个 /etc 目录下的文件全部打包成为 /tmp/etc.tar

```bash
[root@linux ~]# tar -cvf /tmp/etc.tar /etc     <==仅打包，不压缩！
[root@linux ~]# tar -zcvf /tmp/etc.tar.gz /etc <==打包后，以 gzip 压缩
[root@linux ~]# tar -jcvf /tmp/etc.tar.bz2 /etc <==打包后，以 bzip2 压缩
# 特别注意，在参数 f 之后的文件档名是自己取的，我们习惯上都用 .tar 来作为辨识。
# 如果加 z 参数，则以 .tar.gz 或 .tgz 来代表 gzip 压缩过的 tar file ～
# 如果加 j 参数，则以 .tar.bz2 来作为附档名啊～
# 上述指令在执行的时候，会显示一个警告讯息：
# 『tar: Removing leading `/' from member names』那是关於绝对路径的特殊设定。
```

* 范例二：查阅上述 /tmp/etc.tar.gz 文件内有哪些文件？

```bash
[root@linux ~]# tar -ztvf /tmp/etc.tar.gz
# 由於我们使用 gzip 压缩，所以要查阅该 tar file 内的文件时，
# 就得要加上 z 这个参数了！这很重要的！
```

* 范例三：将 /tmp/etc.tar.gz 文件解压缩在 /usr/local/src 底下

```bash
[root@linux ~]# cd /usr/local/src
[root@linux src]# tar -zxvf /tmp/etc.tar.gz
# 在预设的情况下，我们可以将压缩档在任何地方解开的！以这个范例来说，
# 我先将工作目录变换到 /usr/local/src 底下，并且解开 /tmp/etc.tar.gz ，
# 则解开的目录会在 /usr/local/src/etc 呢！另外，如果您进入 /usr/local/src/etc
# 则会发现，该目录下的文件属性与 /etc/ 可能会有所不同喔！
```

范例四：在 /tmp 底下，我只想要将 /tmp/etc.tar.gz 内的 etc/passwd 解开而已

```bash
[root@linux ~]# cd /tmp
[root@linux tmp]# tar -zxvf /tmp/etc.tar.gz etc/passwd
# 我可以透过 tar -ztvf 来查阅 tarfile 内的文件名称，如果单只要一个文件，
# 就可以透过这个方式来下达！注意到！ etc.tar.gz 内的根目录 / 是被拿掉了！
```

* 范例五：将 /etc/ 内的所有文件备份下来，并且保存其权限！

```bash
[root@linux ~]# tar -zxvpf /tmp/etc.tar.gz /etc
# 这个 -p 的属性是很重要的，尤其是当您要保留原本文件的属性时！
```


* 范例六：在 /home 当中，比 2005/06/01 新的文件才备份

```bash
[root@linux ~]# tar -N '2005/06/01' -zcvf home.tar.gz /home
```

* 范例七：我要备份 /home, /etc ，但不要 /home/dmtsai

```bash
[root@linux ~]# tar --exclude /home/dmtsai -zcvf myfile.tar.gz /home/* /etc
```

* 范例八：将 /etc/ 打包后直接解开在 /tmp 底下，而不产生文件！

```bash
[root@linux ~]# cd /tmp
[root@linux tmp]# tar -cvf - /etc | tar -xvf -
# 这个动作有点像是 cp -r /etc /tmp 啦～依旧是有其有用途的！
# 要注意的地方在於输出档变成 - 而输入档也变成 - ，又有一个 | 存在～
# 这分别代表 standard output, standard input 与管线命令啦！
```

## gzip 命令

gzip 是在 Linux 系统中又一个经常使用的对文件进行压缩和解压缩的命令，既方便又好用。

语法：

```bash
gzip [选项] 压缩（解压缩）的文件名
```

该命令的各选项含义如下：

```shell
-c 将输出写到标准输出上，并保留原有文件。
-d 将压缩文件解压。
-l 对每个压缩文件，显示下列字段：
     压缩文件的大小；未压缩文件的大小；压缩比；未压缩文件的名字
-r 递归式地查找指定目录并压缩其中的所有文件或者是解压缩。
-t 测试，检查压缩文件是否完整。
-v 对每一个压缩和解压的文件，显示文件名和压缩比。
-num 用指定的数字 num 调整压缩的速度，-1 或 --fast 表示最快压缩方法（低压缩比），
-9 或--best表示最慢压缩方法（高压缩比）。系统缺省值为 6。
```

指令实例：

```bash
gzip *        # 把当前目录下的每个文件压缩成 .gz 文件。

gzip -dv *    # 把当前目录下每个压缩的文件解压，并列出详细的信息。

gzip -l *     # 详细显示例1中每个压缩的文件的信息，并不解压。

gzip usr.tar  # 压缩 tar 备份文件 usr.tar，此时压缩文件的扩展名为.tar.gz。
```

## 参考资料

* tar命令的详细解释 - CSDN博客
http://blog.csdn.net/eroswang/article/details/5555415/
* tar/gz/bz/gz2/bz2...压缩与解压缩 - CSDN博客
http://blog.csdn.net/yjier/article/details/6859580


