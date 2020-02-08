---
layout: post
title: Vim 使用笔记
date: 2020-01-30 14:17:00 +08:00
categories: linux
tags: vim linux
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->


## vim入门

刚学习Linux的时候，就听说了编辑器之神Vim和神之编辑器Emacs，被看起来叼炸天的字符界面吸引，认为自己学会了使用就真是大牛了。
于是乎先尝试了那些全能配置（spf13-vim），然而一个个插件在众所周知的原因下安装极慢，好不容易装完了，在我的渣渣电脑上启动又慢的不行。
花了很多时间，工作却没做多少，遂产生了把Vim彻底抛弃的想法。可惜在服务器上除了Vim真没有太好的解决方案，通过百度谷歌再百度终于整出了一个适合自己的配置。

这篇文章就是整理记录一下自己使用vim的一些经验。
我不算是vim重度使用者，vim对我最大的帮助就是可以在终端里有一个非常顺手的编辑器，类似于我在Windows上必装的软件Notepad++。
所以我在下面的配置算是比较简单轻便，供大家参考。
说点废话：如果写比较大的项目推荐使用vscode，配合新出的remote-ssh插件可以方便的管理编辑服务器上的项目文件，网速好的时候体验和直接编辑本地文件毫无差别。

### vim安装

首先我们安装[vim-nox](https://packages.debian.org/buster/vim-nox)这个版本的vim。
使用命令是
```bash
sudo apt install vim-nox
```
比起`apt install vim`默认安装的vim，这个版本默认支持python3，不用自己编译，后续安装YouCompleteMe会方便很多。

### vim基本操作

#### vim的模式

很多教程都说vim有三种模式，但这里要加上"可视模式"，在这个模式下面可以很方便的用键盘或鼠标选择文本（原谅我不是一个纯键盘党哈哈）。
模式切换方法参考下图。

![vim-mode](/assets/2020-01-30-vim/vim-mode.png)

#### 入门教程vimtutor

在命令行键入`vimtutor`，即可进入该教程，通过交互操作迅速熟悉vim按键。
作为总(zhuang)结(bi)，这里附上一张快捷键图。

![vi-vim-cheat-sheet](/assets/2020-01-30-vim/vim-cheat-sheet.png)


## vim进阶

### 定制你的vim

 大而全的整套解决方案已经有不少，比如
[spf13-vim](https://github.com/spf13/spf13-vim)，
[SpaceVim](https://github.com/SpaceVim/SpaceVim)。
我曾经尝试过`spf13-vim`，但安装比较麻烦(主要原因是国内网络问题)，后来就没有再装。

下面是我现在一直使用的一个轻简的方案，只安装了最常用的老牌插件，有需要的可以copy。

如果想进一步定制，建议学习一点 vimscript 知识。
经典教程有[Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)。
w3cschool 也有[中文版](https://www.w3cschool.cn/vim/nckx1pu0.html)。


### 轻简DIY方案

插件airline需要一些特殊符号，所以建议安装针对性修改的字体，比如
[consolas-powerline](https://github.com/Znuff/consolas-powerline)

安装方法很简单，首先在`$HOME`目录下新建一个文件`.vimrc`。将下面的内容全部复制进去。
这个配置中我加了很多注释，方便大家学习修改。

```vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" 启用vundle来管理vim插件 {
    " vundle安装方法:
    " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth=1
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
        " 安装插件写在这之后

        " let Vundle manage Vundle, required
        Plugin 'VundleVim/Vundle.vim'
        Plugin 'bling/vim-airline'
        Plugin 'altercation/vim-colors-solarized'
        Plugin 'tomasr/molokai'
        Plugin 'mechatroner/rainbow_csv'

        Plugin 'scrooloose/nerdtree'
        Plugin 'jistr/vim-nerdtree-tabs'  " 多个tab共享一个nerdtree
        " Plugin 'Xuyuanp/nerdtree-git-plugin'

        Plugin 'Valloric/YouCompleteMe'

        " 安装插件写在这之前
    call vundle#end()            " required
    filetype plugin on    " required

    " 常用命令
    " :PluginList       - 查看已经安装的插件
    " :PluginInstall    - 安装插件
    " :PluginUpdate     - 更新插件
    " :PluginSearch     - 搜索插件，例如 :PluginSearch xml就能搜到xml相关的插件
    " :PluginClean      - 删除插件，把安装插件对应行删除，然后执行这个命令即可

    " h: vundle         - 获取帮助

" } vundle的配置到此结束，下面是你自己的配置

set nu!   " 显示行号
syntax on " 代码高亮

set mouse=a         " 启用鼠标
set cursorline      " 突出显示当前行
" set cursorcolumn    " 突出显示当前列


set laststatus=2  "永远显示状态栏
set t_Co=256      "在windows中用xshell连接打开vim可以显示色彩
set background=dark

" 在 vim 的命令模式下输入 :digraph，就可以查看想要的字符，记住字符左边的输入方式。
" 在插入模式下，点击快捷键 Ctrl-k，然后输入上一步你记住的编码，就可以了。

" 设置一个 tab 显示出来是多少个空格的长度，默认8
set tabstop=4
" 这个设置表示缩进用空格来表示，noexpandtab 则是用制表符表示一个缩进。
set expandtab
" 表示在编辑模式的时候按退格键的时候退回缩进的长度，简单的说就是去掉自动缩进产生的空格，当
" set expandtab 的时候如果你不设置这个选项的时候，你必须一格一格的往前删除，
" 如果设置了这个选项的话，就可以一次就往前删除指定个数的空格
set softtabstop=4
" 表示当缩进的时候，每一级的缩进长度
set shiftwidth=4

" Show invisible characters
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
set list

" Theme, color settings {
    "colorscheme solarized
    colorscheme molokai
    " colorscheme desert

    "  solarized theme
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"

    " monokai原始背景色
    let g:molokai_original = 1

    " 让空白字符的颜色不显眼
    " 非可见字符 eol extends precedes 是由 NonText 高亮组来控制显示颜色的
    hi NonText ctermfg=235 " 239
    " nbsp tab trail 是由 SpecialKey 高亮组来定义颜色的
    hi SpecialKey ctermfg=235 " 239
" }

" airline {
    " 打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
    " 我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    " 这个是安装字体后 必须设置此项
    " let g:airline_powerline_fonts = 1   
" }

" nerdtree etc {
    " 在终端启动vim时，共享NERDTree
    " let g:nerdtree_tabs_open_on_console_startup=1
    " 显示书签列表
    " let NERDTreeShowBookmarks=1
" }

" F1 - F5 Key settings {
    " can type :help on my own, thanks.  Protect your fat fingers from the evils of <F1>
    noremap <F1> <Esc>"
    " Toggle NERDTree
    noremap <F2> :NERDTreeMirrorToggle<CR>

    " F3 显示可打印字符开关
    function! HideNumberInfo()
        set list!
        set number!
    endfunc
    nnoremap <F3>  :call HideNumberInfo()<CR>
    " :exec ':set list! list? :set number! number?'<CR>
    " F4 换行开关
    function ToggleWrap()
      if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
      else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
      endif
    endfunction
    nnoremap <F4> :call ToggleWrap()<CR>

    " F6 语法开关，关闭语法可以加快大文件的展示
    nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

    set pastetoggle=<F5>            "    when in insert mode, press <F5> to go to
                                    "    paste mode, where you can paste mass data
                                    "    that won't be autoindented

    " disbale paste mode when leaving insert mode
    au InsertLeave * set nopaste

    " F5 set paste问题已解决, 粘贴代码前不需要按F5了
    " F5 粘贴模式paste_mode开关,用于有格式的代码粘贴
    " Automatically set paste mode in Vim when pasting in insert mode
    function! XTermPasteBegin()
      set pastetoggle=<Esc>[201~
      set paste
      return ""
    endfunction
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" }
```

然后，就如注释里所说的，首先安装插件管理器Vundle

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth=1
```

之后用`vim`命令打开vim，忽视报错信息，输入`:PluginInstall`安装插件。
如果遇到网络问题安装失败，重启再安装一次即可。

之后，编译安装补全插件YouCompleteMe。
注意这里没有C/C++补全支持，如需要建议参考[YCM官网](https://github.com/ycm-core/YouCompleteMe)

```bash
sudo apt install build-essential cmake  # 安装编译所需组件
cd ~/.vim/bundle/YouCompleteMe/
python3 install.py  # 编译安装YouCompleteMe
```

至此安装结束，效果如图

![vim-screenshot](/assets/2020-01-30-vim/vim-screenshot.png)


### 琐碎的知识点


#### 文件编码

以指定的编码打开某文件，如打开windows中以ANSI保存的文件
```
vim file.txt -c "e ++enc=GB18030"
```

vim中的操作：
```vimscript
:set fileencoding               " 显示文件编码格式
:set fileencoding=utf-8   " 文件编码转换，如将一个文件转换成utf-8格式
:set fileformat?                   "  查看文件格式
:set fileformat=unix         " 设置文件格式为 unix，即以`LF`换行
```

#### 代码缩进

缩进单行代码是两个大于号`>>`，回缩是两个小于号`<<`。

如果想要缩进很多行代码的话就按照下面做

```
:10,100>      " 第10行至第100行缩进
:20,80<        " 第20行至第80行反缩进
```
还可以这样

```
1  //在这里按下'v'进入可视模式(shift + v 可以直接选中行)
111111 //光标移动到这里，再按一次大于号'>'缩进一次，按'6>'缩进六次，按'<'回缩。以下同理

function helo{ //将光标移动到'{',在按下'%',光标将会移动到匹配的括号
//这里省略1000行
} //光标会移动到这里，再按一次大于号'>'就可以缩进

// 可视模式中选中代码块，按`=`号可以自动缩进。
```

#### 复制粘贴

在vim中复制粘贴直接用vim命令即可，这里说说如何使用鼠标 (`mouse`选项必须设置，见上配置文件)。

用鼠标在可视模式中复制/粘贴:

1. 在文本的第一个字符上按住鼠标左键，移动鼠标到文本的最后一个字符，然后释放左键。这会启动可视模式并高亮选择区域。(在第一个字符上单击鼠标左键，在文本的最后一个字符单击右键，效果相同)
2. 按 `y` 抽出可视文本到无名寄存器里。
3. 在要插入的位置上按鼠标左键。
4. 按鼠标中键（滚轮）。(效果同输入`P`)


那么如何在终端和其他应用之间复制粘贴呢？
先按住shift键（这样可以将操作直接发送给终端而不是vim），选中要复制的部分，然后单击右键，在菜单中选择复制。
复制前先关闭行号和空白字符显示，这个在上述配置文件中已经绑定了快捷键`<F3>`。

那要是需要复制的文本超过终端显示的行数呢？
这我也没找到办法，我遇到这种情况都是先用`cat`命令将文件内容输出到终端，再复制。
如果你有更好的办法请评论留言^_^。

在vim里，粘贴代码之前最好进入粘贴模式`set paste`，这样就会关闭自动缩进。
将代码粘贴进去之后再关闭粘贴模式`set nopaste`。
这个在上述配置文件中已经绑定了快捷键`<F5>`。

#### 切换查看buffers

注意在vim中buffer和tab不是一个概念。功能类似浏览器标签页的是buffer （在上述配置方案中显示在最上方）。
使用 `:bn`, `:bp`,` :b #`, `:b name`, 和 `ctrl-6` 可以在buffer之间切换. 我喜欢` ctrl-6`这个快捷建。 还有`#ctrl-6` ，可以切换到编号为`#`的buffer。使用` :ls`列出所有buffers, 此外还有插件`MiniBufExpl` 或 `BufExplorer`可供选择。


### 参考资料

* wklken/k-vim  https://github.com/wklken/k-vim
* 在Vim中查看文件编码和文件编码转换 - 简书 https://www.jianshu.com/p/36286fa7a9ed
* Vim Tab Madness. Buffers vs Tabs - Josh Davis https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/

