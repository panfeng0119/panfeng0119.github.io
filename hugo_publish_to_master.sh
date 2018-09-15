#!/bin/bash

# 脚本：自动将public文件夹push到master分支 
# 如果是用 gh-branch，将 master 替换为 gh-branch 就可以

# 日志信息
Date=`date "+%Y-%m-%d %H:%M:%S"`
alias printlog='echo ${Date} INFO'

# 标记当前路径
DIR=`pwd`
printlog "当前目录：${DIR}"

if [[ $? -ne 0 ]]
then
    echo "Please use 'sh $0'."
    exit 1;
fi

printlog "标记 public 文件夹为 master 分支"
rm -rf public
rm -rf .git/worktrees/public/
# 下面两句貌似用不上
# mkdir public  
# git worktree prune
# 进行标记
git worktree add -B master public origin/master
# 清除原来的内容
rm -rf public/*

# 编译
printlog "正在生成网站."
hugo

printlog "正在提交更新"

msg="Rebuilding site ${Date} (publish.sh)"
# 可以考虑设置一个提交参数
# if [ $# -eq 1 ]
#   then msg="$1"
# fi

# 提交
cd public && git add --all && git commit -m "${msg}"

printlog "正在 push"
git push origin master

printlog "Down!"
