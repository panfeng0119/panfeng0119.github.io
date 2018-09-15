#!/usr/bin/env bash

# 脚本：自动将public文件夹push到master分支
work_path=`pwd`
Date=`date "+%Y-%m-%d %H:%M:%S"`
alias log='echo ${Date} INFO'
log "当前目录：${work_path}"
# begin
log "正在生成网站."
hugo

log "克隆master分支."
rm -rf master
git clone https://github.com/panfeng0119/panfeng0119.github.io.git master -b master

cd master
git rm -rf .
cp -rf ../public/* ./
git add -A

msg="rebuilding site ${Date}"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m"${msg}"
log "正在push."
git push -u origin master
log "Down!"
cd ${work_path}
rm -rf master