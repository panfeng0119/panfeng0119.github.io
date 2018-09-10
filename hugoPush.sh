# 脚本：自动将public文件夹push到master分支
work_path=`pwd`
echo "当前目录：${work_path}"
echo "正在生成网站."
hugo -b http://panfeng0119.github.io

echo "克隆master分支."
rm -rf master
git clone https://github.com/panfeng0119/panfeng0119.github.io.git master -b master

cd master
git rm -rf .
cp -rf ../public/* ./
git add -A
git commit -m"site update"
echo "正在push."
git push -u origin master
echo Down!
cd ${work_path}
rm -rf master
