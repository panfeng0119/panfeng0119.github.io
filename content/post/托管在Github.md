+++
title = "Hugo + GitHub 部署个人站点"

date = 2018-09-15T00:00:00
lastmod = 2018-09-15T00:00:00
draft = false

authors = ['潘峰']

tags = ["GitHub Pages"]
summary = "在 GitHub 上部署个人网站."

+++

完整内容请参阅 [Hosting & Deployment](https://gohugo.io/hosting-and-deployment/).

我们可以将 Hugo 生成的站点托管在 GitHub Pages 上，并使用简单的shell脚本自动完成整个过程。假设您已完成：

1. 已安装 [Git](https://git-scm.com/downloads) 版本 2.8 以上.
2. 在 [GitHub](https://github.com/) 中创建好了仓库: &lt;USERNAME&gt;.github.io.
3. 有一个即将发布的Hugo网站，起码已完成[快速入门](https://gohugo.io/getting-started/quick-start/)步骤.

***
## 一、<b>通过两个仓库来创建 GitHub Pages</b>

具体描述，请参阅文档 [GitHub Pages documentation](https://help.github.com/articles/user-organization-and-project-pages/#user--organization-pages)，以确定您要创建哪种类型的站点.

注意：

1. 仓库名必须用&lt;USERNAME&gt;.github.io
2. 网站内容必须存放在 master 分支


### 步骤 

最简单的方法就是将 Hugo 文件和生成的内容分别发布到两个不同的仓库(Repositoriy)中。

1. 创建两个仓库 <p> 一个存放源码的仓库： `<YOUR-PROJECT>`  <font color=#C0C0C0>（如：blog）</font> </br> 一个托管Hugo网站的仓库： `<USERNAME>.github.io` </p>
2. 克隆源码仓库到本地 <p> git clone &lt;OUR-PROJECT-URL&gt; </br> cd &lt;YOUR-PROJECT&gt; </p>
3. 启动网站服务，确保网站能正常运行 <p> hugo server </br> 访问网站 http://localhost:1313
4. 创建 git 子模块，命名为 *public* <font color=#C0C0C0>（用来托管网站）</font> <p> git submodule add -b master `git@github.com:<USERNAME>/<USERNAME>.github.io.git public` *public*
5. 运行脚本，将网站 push 到`<USERNAME>.github.io` <p> chmod +x deploy.sh  ./deploy.sh"提交消息(可选)" </p> 
6. 将源代码 push 到 `<YOUR-PROJECT>`

deploy.sh脚本：
```
#!/bin/bash
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

现在！您的个人页面成功地部署在 `https//<USERNAME>.github.io`

<p><font color=#778899>补充：如果需要指定 Hugo 生成网站的输出目录，可以在配置文件中 config.toml 中设置变量 publishDir = "docs". </font></p>

## 二、<b>通过两个分支来创建 GitHub Pages</b>

我们还可以指定默认分支来托管源代码，并将发布的站点指向单独的分支，虽然比上面的方法复杂，但他的优点在于：

* 只用一个仓库，方便维护和版本控制
* 直接使用默认的 *public* 目录，不必指定 Git 子模块或输出目录

不同的仓库类型，需要托管的分支是不同的

* 如果仓库在 `https//github.com/<USERNAME>/<USERNAME>.github.io` ，托管分支是 **gh-pages** 
* 如果仓库在 `https//<USERNAME>.github.io` ，托管分支是 **master**

第二种情况需要到仓库中设置默认分支<font color=#F08080>（非 master 分支）</font>，设置方法如下

1. 进入仓库 `https//<USERNAME>.github.io`

2. 点击设置 **Settings** 导航栏

3. 在左侧 **Options** 找到 **Branches**

4. 选择 **Default branch**

您还可以告诉GitHub页面将主分支视为已发布的站点或指向单独的gh-pages分支。后一种方法有点复杂但有一些优点：

这些步骤只需要完成一次。将 upstream 替换为remote的名称; 例如，origin：


Preparations for gh-pages Branch 
These steps only need to be done once. Replace upstream with the name of your remote; e.g., origin:


Add the public Folder

添加public文件夹 
首先，将public文件夹添加到项目根目录下的.gitignore文件中，以便在主分支上忽略该目录

echo "public" >> .gitignore


初始化 gh-pages 分支
You can now initialize your gh-pages branch as an empty [独立分支（orphan branch）](https://git-scm.com/docs/git-checkout/#git-checkout---orphanltnewbranchgt):

git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push upstream gh-pages
git checkout master
Build and Deployment 
Now check out the gh-pages branch into your public folder using git’s worktree feature. Essentially, the worktree allows you to have multiple branches of the same local repository to be checked out in different directories:

rm -rf public
git worktree add -B gh-pages public upstream/gh-pages
Regenerate the site using the hugo command and commit the generated files on the gh-pages branch:

commit-gh-pages-files.sh

hugo
cd public && git add --all && git commit -m "Publishing to gh-pages" && cd ..
If the changes in your local gh-pages branch look alright, push them to the remote repo:

git push upstream gh-pages
Set gh-pages as Your Publish Branch
In order to use your gh-pages branch as your publishing branch, you’ll need to configure the repository within the GitHub UI. This will likely happen automatically once GitHub realizes you’ve created this branch. You can also set the branch manually from within your GitHub project:

Go to Settings → GitHub Pages
From Source, select “gh-pages branch” and then Save. If the option isn’t enabled, you likely have not created the branch yet OR you have not pushed the branch from your local machine to the hosted repository on GitHub.
After a short while, you’ll see the updated contents on your GitHub Pages site.

Put it Into a Script 
To automate these steps, you can create a script with the following contents:

publish_to_ghpages.sh

#!/bin/sh

DIR=$(dirname "$0")

cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public upstream/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"
This will abort if there are pending changes in the working directory and also makes sure that all previously existing output files are removed. Adjust the script to taste, e.g. to include the final push to the remote repository if you don’t need to take a look at the gh-pages branch before pushing. Or adding echo yourdomainname.com >> CNAME if you set up for your gh-pages to use customize domain.

Deployment of Project Pages from Your master Branch 
To use master as your publishing branch, you’ll need your rendered website to live at the root of the GitHub repository. Steps should be similar to that of the gh-pages branch, with the exception that you will create your GitHub repository with the public directory as the root. Note that this does not provide the same benefits of the gh-pages branch in keeping your source and output in separate, but version controlled, branches within the same repo.

You will also need to set master as your publishable branch from within the GitHub UI:

Go to Settings → GitHub Pages
From Source, select “master branch” and then Save.
Use a Custom Domain 
If you’d like to use a custom domain for your GitHub Pages site, create a file static/CNAME. Your custom domain name should be the only contents inside CNAME. Since it’s inside static, the published site will contain the CNAME file at the root of the published site, which is a requirements of GitHub Pages.

Refer to the official documentation for custom domains for further information.

