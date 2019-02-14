#!/bin/bash
#本地要更新的目录
project="/www/wwwroot/kwok.ikwok.cn/"
#github仓库地址
github_url="https://github.com/kwokzc/kwok/archive/master.zip"
#更新确认
clear
echo -e "更新位置： ${project}\n"
echo -e "仓库地址： ${github_url}\n"
echo -e "更新前会删除之前的kwok-sh文件夹\n"
read -p "是否开始更新(输入y确定)：" update
if [ "$update" = "y" ];then
	#清空之前的文件
	rm -rf /root/kwok-sh/
	#备份项目
	echo -e "\n开始备份项目文件\n"
	mkdir -p /root/kwok-sh/backup/ && echo -e "\n已创建备份目录\n"
	cp -r /www/wwwroot/kwok.ikwok.cn/ /root/kwok-sh/backup/ || (echo -e "\n备份失败\n";exit 1)
	echo -e "\n备份完成\n"
	ls -l /root/kwok-sh/backup/
	#下载github最新仓库文件
	echo -e "\n开始下载最新github仓库文件\n"
	cd /root/kwok-sh/
	wget -c ${github_url} && echo -e "\n下载完成\n"
	#判断文件是否存在，如不存在则退出
	if [ ! -f "/root/kwok-sh/master.zip" ]; then
		echo -e "\ngithub仓库下载失败或有误，请检查文件\n"
		exit 1
	fi
	#解压
	unzip -o master.zip || yum install -y unzip
	unzip -o master.zip || (echo -e "\n解压失败，请手动检查\n";exit 1)
	echo -e "\n解压完成\n"
	#替换
	rm -rf $project || (echo -e "\n删除原项目失败\n";exit 1)
	echo -e "\n已删除原项目\n"
	mv /root/kwok-sh/kwok-master/ $project || (echo -e "\n移动项目失败\n";exit 1)
	echo -e "\n项目文件移动完成\n"
	#还原配置文件
	#database.php hostname为localhost不含隐私信息，已上传至github，无需还原配置文件
	#cp /kwok-sh/backup/database.php ${project}application/
	#更新完成
	ls -ls $project 
	echo -e "\n项目已更新完成\n"
else
	echo -e "输入错误，退出程序"
	exit 1
fi
