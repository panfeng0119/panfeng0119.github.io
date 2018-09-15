#!/bin/sh

DIR=$(dirname "$0")
work_path=`pwd`

cd $DIR
echo $DIR
echo ${work_path}
# if [[ $(git status -s) ]]
# then
#     echo "当前目录存在更改，请先提交. 详细请输入命令 git status -s."
#     exit 1;
# fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out master branch into public"
git worktree add -B master public upstream/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating master branch"
cd public && git add --all && git commit -m "Publishing to master (publish.sh)"