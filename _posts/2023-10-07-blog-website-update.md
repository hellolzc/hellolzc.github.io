---
layout: post
title: 博客小站翻修小记
date: 2023-10-07 12:50:00 +08:00
categories: web
tags: Jekyll Github
---


实话说，用Github Pages写博客虽然显得高端，但实际上并没有那么方便。
我中途也想换用CSDN之类的网站，但试了试感觉上面的氛围还是不符合自己的性子。

这期间发现[喵神](http://onevcat.com)的博客居然更新了，功能丰富大变样，自己也想把自己的博客捡起来。
先尝试了喵神用的[chirpy](https://github.com/cotes2020/jekyll-theme-chirpy/)模版，
结果发现虽然功能很多，但默认的效果不如我现在的配置好看。
所以这里先试着将喵神博客的一些新特性加入到自己的网站中，
在此过程中，记录一下自己的经历，供后续使用该[vno-jekyll](vno-jekyll)模版的同行参考。

第一步自然是配环境，我原来用的是双系统，在Ubuntu下配置的写博客环境。
由于现在的工作只在服务器上用Linux，所以放弃双系统的做法了。
我现在用VirtualBox安装了一个Linux Mint的虚拟机，
在虚拟机里安装了ruby环境。（Ubuntu的snap太讨厌；WSL和Windows绑定过深不方便迁移）

## 环境配置和升级

值得一提的是，相比上次配环境的方法（见[n年前博客](/2016/04/used-jekyll-to-create-my-github-blog/index.html)），现在很多包都升级了，装环境更简单了。
具体做法参考了[Jekyll Docks](https://jekyllrb.com/docs/installation/ubuntu/)

安装方式非常简单:

```bash
# Install Ruby and other prerequisites:
sudo apt-get install ruby-full build-essential zlib1g-dev

# Add environment variables to your ~/.bashrc file to configure the gem installation path:
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Finally, install Jekyll and Bundler:
gem install jekyll bundler
```

由于ruby已经升级到了3.0，后续要升级项目里面的包。

先尝试直接安装
```bash
# 设置项目环境防止和别的项目冲突，旧命令是 `bundle install --path=vendor/bundle`, 已废弃
bundle config set --local path 'vendor/bundle'
bundle install  # 或者直接输入bundle
```

这个过程报错了，有些包和当前ruby版本不兼容：

```
ruby_dep-1.5.0 requires ruby version >= 2.2.5, ~> 2.2, which is incompatible with the current version, ruby 3.0.2p107
```

推荐的做法是直接升级报错的包：

```bash
bundle update ruby_dep jekyll-watch listen
```

但我尝试了之后升级不行，所以删除了`Gemfile.lock` 重新安装, 这样`Gemfile.lock`文件会重新生成。

然后运行`bundle exec jekyll s`就可以在本地预览博客内容了。


## 添加支持 utterances 评论插件

之前我用的是disqus评论插件，首先国内加载比较慢，然后还需要评论者注册disqus账号。
结果博客读者倾向于直接发邮件给我，没有什么人评论（捂脸）。
所以这里加入支持 [utterances](https://utteranc.es/) 。

utterances 是一个开源的，基于 Github Issue API 工作的插件系统。

参考了以下文章
- 移除 Disqu 替換到 utteranc 來使用 github issue 作為文章評論
https://www.evanlin.com/jekyll-remove-disqus/
- 官方页面 https://utteranc.es/

步骤也很简单。
第一步，参考官方页面安装github app。这里我把utterances安装到了一个新建的github repo。

第二步，修改现在Jekyll博客的模版。
我在`_includes/comments.html`下面依葫芦画瓢添加了如下内容：

<!-- 转义，解决花括号在 Jekyll 被识别成 Liquid 代码的问题 - https://cloud.tencent.com/developer/article/1341165 -->
```
{% raw %}
    {% elsif site.comment.utterances %}
    <div id="utterances_thread"></div>
    <script src="https://utteranc.es/client.js"
        repo="{{ site.comment.utterances }}"
        issue-term="pathname"
        theme="github-light"
        crossorigin="anonymous"
        async>
    </script>
{% endraw %}
```

配置文件`_config.yml`也做对应的修改：
```yaml
# Comment
comment:
    # disqus: hellolzc
    # duoshuo: 
    utterances: hellolzc/hellolzc.github.io-comments
```

大功告成！！！欢迎大家在下面评论！


## 添加网站访问计数功能

为了提高自己的成就感，给博客添加访问计数功能。

参考了：
- Jekyll博客统计访问量，阅读量工具总结--LeanCloud，不蒜子，Valine，Google Analytics — 浮云的博客 https://last2win.com/2020/01/19/GitHub-jekyll-view-counter/
- 不蒜子 - 极简网页计数器 http://busuanzi.ibruce.info/

试了LeanCloud国际版国内用不了，国内版又需要采集个人信息不想用。
Google Analytics国内访问也不方便，最后选择的不蒜子。

这种方式只需要对`_includes/footer.html`做添加两行代码：

```html
        <script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
        <span id="busuanzi_container_site_pv">本站总访问量<span id="busuanzi_value_site_pv"></span>次</span>
```

显示效果如下：

-----------------------

<p><span id="busuanzi_container_site_pv">本站总访问量<span id="busuanzi_value_site_pv"></span>次</span></p>

-----------------------

哈哈，先放这里，等次数足够多了再放到页脚。

## 访问速度优化

曾经身边有几个朋友反应过我的博客访问加载特别慢，
我刚开始以为是背景图片太大了，所以先是优化了背景图片大小。
但后来发现，背景图片加载和正文加载是不冲突的，现在国内访问的问题是正文加载太慢。

我用Chrome浏览器的开发者工具来检查加载速度。

先清空浏览器缓存，之后在Network选项卡页面检查不同项目的加载时间，
发现`font-awesome.min.css` 这个文件国内加载超过了20s。
不能忍啊！

我参考这篇文章：

- VuePress博客优化访问速度  https://cloud.tencent.com/developer/article/2119732

优化方式是更换了个 cdn ，现在用的 cdn 是 [staticfile](https://staticfile.org/)，由七牛云和掘金提供。

只用修改`/_includes/head.html`这个页面：

```html
<!-- 之前的地址 -->
<link href="//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<!-- 修改后的地址 -->
<link href="https://cdn.staticfile.org/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
```

OK，现在国内国外都不卡啦~
