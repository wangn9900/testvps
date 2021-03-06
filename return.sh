curl -s --connect-timeout 4 -m 10 http://ip-api.com/json/ | grep -q -i "China"
if [[ $? == 0 ]];then
	curl -s --connect-timeout 4 -m 10 http://ip-api.com/json/ | grep -q -i "hk"
	if [[ $? != 0 ]];then
		echo
		echo "中国大陆的服务器无需检测,不用看,肯定很优秀!!"
		echo
		exit;
	fi
fi
echo -e "\n该小工具可以为你检查本服务器到中国北京、上海、广州的[回程网络]类型\n"
read -p "按Enter(回车)开始启动检查..." sdad

iplise=(219.141.136.10 202.106.196.115 211.136.28.231 202.96.199.132 211.95.72.1 211.136.112.50 61.144.56.100 211.95.193.97 120.196.122.69)
iplocal=(北京电信 北京联通 北京移动 上海电信 上海联通 上海移动 广州电信 广州联通 广州移动)
echo "开始安装traceroute命令..."
yum -y install mtr unzip
clear
echo -e "\n脚本李子所有 | mjj随便折腾 "
echo -e "\ntest提醒您: 正在测试,请骚等..."
echo -e "——————————————————————————————\n"
for i in {0..8}; do
	mtr -r --n --tcp ${iplise[i]} > /root/traceroute_testlog
	grep -q "59\.43\." /root/traceroute_testlog
	if [ $? == 0 ];then
		grep -q "202\.97\."  /root/traceroute_testlog
		if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2 GT\033[0m"
		else
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2 GIA\033[0m"
		fi
	else
		grep -q "202\.97\."  /root/traceroute_testlog
		if [ $? == 0 ];then
			grep -q "219\.158\." /root/traceroute_testlog
			if [ $? == 0 ];then
				echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
			else
				echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;34m电信163\033[0m"
			fi
		else
			grep -q "219\.158\."  /root/traceroute_testlog
			if [ $? == 0 ];then
				echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
			else
				grep -q "223\.120\."  /root/traceroute_testlog
				if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
				else
					grep -q "221\.183\."  /root/traceroute_testlog
					if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动cmi\033[0m"
					else
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:其他"
					fi
				fi
			fi
		fi
	fi
echo 
done
rm -rf /root/traceroute_testlog
echo -e "\n——————————————————————————————\n提醒: 本脚本测试结果为TCP回程路由,非ICMP回程路由 仅供参考 谢谢\n"
