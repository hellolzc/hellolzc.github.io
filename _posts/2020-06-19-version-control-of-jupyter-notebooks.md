---
layout: post
title: Jupyter Notebook版本控制
date: 2020-06-19 20:31:00 +08:00
categories: coding
tags: python
---

Jupyter Notebook是一个非常方便做机器学习和数据分析的工具，但由于它将代码和输出混在了一起，非常不利于用Git进行版本控制。

那么，可以将notebook转成python脚本再控制啊。

完成 .ipynb 文件转换成 .py 文件的工作可以通过 `post-save` 的钩子自动进行。

只需要按照如下所示，修改 ipython 的配置文件即可：
```
~/.jupyter/ipython_notebook_config.py
```

添加以下代码：

```python
### If you want to auto-save .html and .py versions of your notebook:
# modified from: https://github.com/ipython/ipython/issues/8009
# Solution2: https://jupyter-notebook.readthedocs.io/en/stable/extending/savehooks.html
import os
from subprocess import check_call
import re

def clear_prompt(dir_path, nb_fname, log_func):
    """remove the number in '# In[ ]:'"""
    name, ext = os.path.splitext(nb_fname)
    pattern = re.compile(r'^# In\[\d+\]:')

    for n_ext in ['.py', '.txt']:
        script_name = os.path.join(dir_path, name+n_ext)
        if os.path.exists(script_name):
            new_lines = []
            with open(script_name, 'rt') as f:
                lines = f.readlines()
            for line in lines:
                new_line = re.sub(pattern, '# In[ ]:', line)
                new_lines.append(new_line)
            with open(script_name, 'wt') as f:
                f.writelines(new_lines)
            log_func('Remove number in "# In[ ]:"! File Name: %s' % script_name)
            break

def post_save(model, os_path, contents_manager):
    """post-save hook for converting notebooks to .py scripts"""
    if model['type'] != 'notebook':
        return # only do this for notebooks
    d, fname = os.path.split(os_path)
    check_call(['jupyter', 'nbconvert', '--to', 'script', fname], cwd=d)  # '--no-prompt',
    log = contents_manager.log
    # log.info('Filename:%s'%fname)
    clear_prompt(d, fname, log.info)
    # check_call(['ipython', 'nbconvert', '--to', 'html', fname], cwd=d)

c.FileContentsManager.post_save_hook = post_save

```

建议将notebook放在一个单独的目录下面，这样生成的py文件就可以和其他代码很好的区分开了。
