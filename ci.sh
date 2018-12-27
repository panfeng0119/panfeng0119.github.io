#!/bin/bash
# 脚本：自动化本地源代码 push

work_path=`pwd`

# 日志信息
Date=`date "+ %Y %m %d %H:%M"`

# 标记当前路径
DIR=`pwd`
echo "当前目录：${DIR}"

if [[ $? -ne 0 ]]
then
    echo "Please use 'sh $0'."
    exit 1;
fi

msg="${Date} (Push Script)"
# 可以考虑设置一个提交参数
if [ $# -eq 1 ]
  then msg="$1"
fi

# 提交
git add --all && git commit -m "${msg}"

echo "正在 push"
git push origin hugo

sh hugo-release.sh
echo "Down!"