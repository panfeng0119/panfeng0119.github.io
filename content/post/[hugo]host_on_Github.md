+++
title = "Hugo + GitHub 部署个人站点"

date = 2018-09-15T00:00:00
lastmod = 2018-09-15T00:00:00
draft = false

authors = ['潘峰']

tags = ["GitHub Pages"]
summary = "在 GitHub 上部署个人网站有两种方式，一种是利用两个仓库，一种是用两个分支..."

+++

完整内容请参阅 [Hosting & Deployment](https://gohugo.io/hosting-and-deployment/).

我们可以将 Hugo 生成的站点托管在 GitHub Pages 上，并使用简单的shell脚本自动完成整个过程。假设您已完成：

1. 已安装 [Git](https://git-scm.com/downloads) 版本 2.8 以上.
2. 需要发布的Hugo网站，起码已完成[快速入门](https://gohugo.io/getting-started/quick-start/).
3. 在 [GitHub](https://github.com/) 中创建好了仓库: &lt;USERNAME&gt;.github.io.

## <b>准备工作</b>
不同的仓库类型，需要托管的分支是不同的。具体描述，请参阅文档 [GitHub Pages doc](https://help.github.com/articles/user-organization-and-project-pages/#user--organization-pages)，以确定您要创建哪种类型的站点.

从逻辑上，常用两种类型的仓库，对应的分支为

| `https://github.com/<USERNAME>/<USERNAME>.github.io` | `https://<USERNAME>.github.io` |
| :------| :------ |
| 网站分支 -> <font face="Aria"><b>gh-pages</b></font> | 网站分支 -> <font face="Aria"><b>master</b></font> |
| 源码分支 -> <font face="微软雅黑"><b>任意</b> </font>| 源码分支 -> <font face="微软雅黑"><b>任意</b></font> |


我们用第二种类型，需要注意两点：

  1. 仓库名必须用&lt;USERNAME&gt;.github.io <br>
  2. 网站内容必须存放在 master 分支

---

## 一、<b>通过两个仓库来创建 GitHub Pages</b>

最简单的方法就是将 Hugo 文件和生成的内容分别发布到两个不同的仓库(Repositoriy)中。

  1. 创建两个仓库 <p> 一个存放源码的仓库： `<YOUR-PROJECT>`  <font color=#F08080>（如：blog）</font> </br> 一个托管Hugo网站的仓库： `<USERNAME>.github.io` </p>
  2. 克隆源码仓库到本地 <p> git clone &lt;OUR-PROJECT-URL&gt; </br> cd &lt;YOUR-PROJECT&gt; </p>
  3. 启动网站服务，确保网站能正常运行 <p> hugo server </br> 访问网站 http://localhost:1313
  4. 创建 git 子模块，命名为 *public* <font color=#F08080>（用来托管网站）</font> <p> git submodule add -b master `git@github.com:<USERNAME>/<USERNAME>.github.io.git public` *public*
  5. 运行脚本，将网站 push 到`<USERNAME>.github.io` <p> chmod +x deploy.sh  ./deploy.sh"提交消息(可选)" </p> 
  6. 将源代码 push 到 `<YOUR-PROJECT>`


```
#!/bin/bash
# 文件名：deploy.sh
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
Date=`date "+%Y-%m-%d %H:%M:%S"`

# Build the project.
hugo

# Go To Public folder
cd public

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site ${Date}"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
```

现在！您的个人页面成功地部署在 `https://<USERNAME>.github.io`

<p><font color=#778899>补充：如果需要指定 Hugo 生成网站的输出目录，可以在配置文件中 config.toml 中设置变量 publishDir = "docs". </font></p>

## 二、<b>通过两个分支来创建 GitHub Pages</b>

我们还可以指定默认分支来托管源代码，并将发布的站点指向单独的分支，虽然比上面的方法复杂，但他的优点在于：

* 只用一个仓库，方便维护和版本控制
* 直接使用默认的 *public* 目录，不必指定 Git 子模块或输出目录

我们需要到仓库中新建一个托管源代码的分支，并设置为默认分支<font color=#F08080>（非 master 分支）</font>，设置方法如下

1. 进入仓库 `https://<USERNAME>.github.io` ，点击导航栏的设置 <font face="woff2"><strong>Settings</strong><font>

2. 在左侧 <font face="woff2"><strong>Options</strong><font> 找到 <font face="woff2"><strong>Branches</strong><font> 

3. <font face="woff2"><strong>Default branch</strong><font> 选择源码托管的分支 <font color=#F08080>（如 hugo）</font>

### 2.1 初始化
接下来的步骤在每次 clone 下来后只需要完成一次。默认的 `（upstream` 的名称 origin
<font color=#F08080>（upstream 是远程仓库在本地的简写名称，可以通过 git remote -v 来查看 ）</font>

现在，我们用 `https://<USERNAME>.github.io` 仓库，源码分支为 **hugo** ，发布网站的分支为 **master**

  1. 克隆仓库到本地，默认分支是 **hugo** <p> git clone &lt;Repositoriy-URL&gt; </br> cd &lt;Repositoriy&gt; </p>
  2. 切换到 **master** 分支，进行设置 <p> 
    git checkout master </br> 
    git reset --hard </br> 
    git commit --allow-empty -m "Initializing master branch" </br> 
    git push origin master</br>
    git checkout master </p>
  3. 切换到 **hugo** 分支<p> 
    echo public >> .gitignore </br> 
    rm -rf public</br> 
    rm -rf .git/worktrees/public/" </br> 
    git worktree add -B master public origin/master </br></p>

### 2.2 启动服务并push到分支
现在我们只需要启动服务，检查网站正常运行，就可以通过脚本来push了  <font color=#F08080>（脚本需要 chmod +x deploy.sh）</font>

```
#!/bin/bash
# 文件名：deploy.sh
# 脚本：自动将public文件夹push到master分支
# 如果是用 gh-branch，将 master 替换为 gh-branch 就可以

# 日志信息
Date=`date "+%Y-%m-%d %H:%M:%S"`
alias printlog='echo ${Date} INFO'

# 标记当前路径
DIR=`pwd`
printlog "当前目录：${DIR}"

printlog "标记 public 文件夹为 master 分支"
rm -rf public
rm -rf .git/worktrees/public/

git worktree add -B master public origin/master
# 清除原来的内容
rm -rf public/*

# 编译
printlog "正在生成网站."
hugo

printlog "正在提交更新"
msg="Rebuilding site ${Date} (publish.sh)"

# 提交
cd public && git add --all && git commit -m "${msg}"

printlog "正在 push"
git push origin master

printlog "Down!"

```

***

### 附录

知识点：

git worktree

利用 upstream 标记更多的远程仓库地址

脚本中获取相对路径 DIR=$(dirname "$0")