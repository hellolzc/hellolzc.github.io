---
layout: post
title: 充分利用服务器加速机器学习研究
date: 2020-02-02 18:55:00 +08:00
categories: linux
tags: machine-learning linux
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->


作为一个机器学习/深度学习 用户，PC已经不能满足你的计算需求，使用远程服务器又感觉诸多不便。
直接给服务器安装一个图形界面也是一个可行的办法。但这种交互方式对网速要求很高，占用资源也较多，很多服务器上都没有安装。
此文旨在提供一个解决方案地图，讨论的都是没有图形界面的情况。

技能树如图：

![skill-tree](/assets/2020-02-02-server/skill-tree.png)

针对上图提出的各个技能，这里整理了一下我学习时看的网络资源。


## 环境管理

### Anaconda

提供了机器学习一整套环境，还可以管理多个Python版本环境，省了很多事。

* Anaconda多环境多版本python配置指导 - 简书<br>
  来源网址：<https://www.jianshu.com/p/d2e15200><br>
  外文原文： <https://conda.io/projects/conda/en/latest/user-guide/getting-started.html>

* 安装conda后取消命令行前出现的base，取消每次启动自动激活conda的基础环境, 使用ubuntu 自带的Python环境 - clemente - 博客园<br>
  <https://www.cnblogs.com/clemente/p/11231539.html>

### virtualenv

Anaconda配置的虚拟环境适合给整个系统使用。
而virtualenv适合单个项目使用，尤其当你下载了github上一个python开源项目，要单独给他准备一个环境来开发时。

* Python 虚拟环境：Virtualenv - 我的成长之路 - ITeye博客<br>
来源网址： <http://liuzhijun.iteye.com/blog/1872241>

* windows上virtualenv 安装及使用 - 刘春明的博客<br>
来源网址： <https://blog.csdn.net/liuchunming033/article/details/46008301>


### Docker

* 这可能是最为详细的Docker入门吐血总结_彪锅锅来啦-CSDN博客<br>
  <https://blog.csdn.net/deng624796905/article/details/86493330>

## 终端

### shellscript

* Linux Shell Scripting Tutorial - A Beginner's handbook<br>
  <http://www.freeos.com/guides/lsst/index.html>

* The Shell Scripting Tutorial<br>
  <https://www.shellscript.sh/>

### Vim

看我的上一篇博客[《Vim 使用笔记》](https://hellolzc.github.io/2020/01/note-of-vim/)。

### Tmux

程序跑太久终端不敢关？网络一断程序就崩溃？传统nohub解决方案功能太弱？
请学习tmux工具。

* 如何使用Tmux提高终端环境下的效率<br>
来源网址：<https://linux.cn/article-3952-1.html><br>
转载自： <http://xmodulo.com/2014/08/improve-productivity-terminal-environment-tmux.html> 

上面这个博客少说了一点，tmux输出是可以翻页的，也就是说，历史记录不只有屏幕上那一点。
按下`CTRL-b`后再用`PageUp`和`PageDown`即可翻页。

## 科学上网

### 换源

非科学上网的解决方案。
换源之后apt，Python，Annaconda的安装速度会快非常多。
换源办法直接参考对应源的帮助页面。

### Shadowsocks

经典梯子。

### Proxychains

虽然可以通过设置环境变量让程序走代理，但实际中我用这种办法很少奏效。
Proxychains成了不二之选，搭配上面梯子使用，让终端程序走代理。

## 访问文件

### Samba

这种方法适合从Windows访问Linux系统上的文件，非常方便。

### sshfs

这种方法适合在Linux系统上相互访问，只要能用ssh登录的服务器都可以使用。
将一个服务器的目录挂载到另一个服务器上，不用来回复制文件啦。Anaconda环境也可以挂载哦。

* 使用 SSHFS 挂载远程的 Linux 文件系统及目录 \| 《Linux就该这么学》<br>
  <https://www.linuxprobe.com/sshfs-linux-fires.html>

### sftp

只要能用ssh登录的服务器都可以使用，临时使用很方便。

## 远程编辑/执行/Debug

### PyCharm

PyCharm专业版支持使用远程环境开发，学生可以申请免费版。
不过我的体验是这种办法没有下面的方便。

### Vscode Remote-SSH

2019年，微软发布了 VS Code Remote，远程开发体验甚至超过本地。
你可以不用配置本地的开发环境，代码分析，Debug全部在远程进行。
真的没有什么理由再去捣鼓什么vim插件了。

*  玩转VSCode插件之Remote-SSH - 李羽飞 - 博客园<br>
   <https://www.cnblogs.com/liyufeia/p/11405779.html>

### Jupyter Notebook

远程执行的时候需要可视化怎么办？你需要Jupyter！
支持Python、R等多种语言，配上TableOfContent、Variable Inspector等插件，效率翻倍！

* 搭建 ipython/jupyter notebook 服务器<br>
来源网址： <https://bitmingw.com/2017/07/09/run-jupyter-notebook-server/>

* Jupyter Notebook 快速入门（上） - 精品 IT 资源分享<br>
来源网址：<https://codingpy.com/article/getting-started-with-jupyter-notebook-part-1/><br>
外文原文链接：<https://hub.packtpub.com/getting-started-jupyter-notebook-part-1/>

* Jupyter Notebook 快速入门（下）| 编程派 | Coding Python<br>
来源网址： <http://codingpy.com/article/getting-started-with-jupyter-notebook-part-2/><br>
外文原文链接 ：<https://hub.packtpub.com/getting-started-jupyter-notebook-part-2/>

* 27 个Jupyter Notebook的小提示与技巧 - CSDN博客<br>
来源网址： <https://blog.csdn.net/gx19862005/article/details/60141711><br>
外文原文链接：<https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/>

* jupyter中添加conda环境 - LeonHuo - 博客园<br>
来源网址： <https://www.cnblogs.com/hgl0417/p/8204221.html>


### Pdb

一直用print的方法来调试终端里的程序是不是很累？你需要学习一下如何使用Python自带的Debug工具。
在Jupyter NoteBook中，使用`%pdb`Magic命令即可开启。

* pdb — The Python Debugger — Python 3.8.0 documentation
  <https://docs.python.org/3/library/pdb.html>

* 10分钟教程掌握Python调试器pdb
  <https://zhuanlan.zhihu.com/p/37294138>


## 一致性维护

### git版本控制

Jupyter NoteBook如何做版本控制？可以参考下面这个博文

* Jupyter Notebook 最佳实践 - 精品 IT 资源分享<br>
  来源网址：<https://codingpy.com/article/jupyter-notebook-best-practices/><br>
  外文原文链接： <https://www.svds.com/jupyter-notebook-best-practices-for-data-science/>
