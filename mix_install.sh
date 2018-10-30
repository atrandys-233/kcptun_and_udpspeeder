#!/bin/bash

#    "========================="
#    " 介绍：适用于CentOS7"
#    " 作者：atrandys"
#    " 网站：www.atrandys.com"
#    " Youtube：atrandys"
#    "========================="

#开始
echo
echo "========================="
echo " 介绍：适用于CentOS7"
echo " 作者：atrandys"
echo " 网站：www.atrandys.com"
echo " Youtube：atrandys"
echo "========================="
echo
echo "给即将安装的软件设置一个文件夹名称,新建文件夹的目录在/usr/src/下"
echo "如果多开，文件夹名称不能相同，举例可设置为game1、game2"
read -p "请输入文件夹名称:" yourdir
ifdir="/usr/src/"$yourdir
if [ ! -d "$ifdir" ]; then
#下载几个配置文件
echo "输入kcptun监听的端口，不要使用已占用端口"
read -p "请输入数字:" kcptunport
echo "输入udpspeeder监听的端口，不要使用已占用端口"
read -p "请输入数字:" udpspeederport
mkdir /usr/src/$yourdir
mkdir /usr/src/$yourdir/client
cd /usr/src/$yourdir/client
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/start.bat
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/stop.bat
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/kcptun_client.json
cd /usr/src/$yourdir
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/kcptun_server.json
wget https://github.com/yobabyshark/kcptun_and_udpspeeder/raw/master/speederv2_amd64
wget https://github.com/yobabyshark/kcptun_and_udpspeeder/raw/master/server_linux_amd64
chmod +x speederv2_amd64 server_linux_amd64

#设置参数
serverip=$(curl icanhazip.com)
echo "输入本地代理软件监听的端口"
read -p "请输入数字:" port
sed -i "s/your_server_ip/$serverip/" /usr/src/$yourdir/client/kcptun_client.json
sed -i "s/kcptun_server_port/$kcptunport/" /usr/src/$yourdir/client/kcptun_client.json
sed -i "s/your_server_ip/$serverip/" /usr/src/$yourdir/client/start.bat
sed -i "s/udpspeeder_server_port/$udpspeederport/" /usr/src/$yourdir/client/start.bat
sed -i "s/your_server_port/$port/" /usr/src/$yourdir/kcptun_server.json
sed -i "s/kcptun_server_port/$kcptunport/" /usr/src/$yourdir/kcptun_server.json

#启动服务
nohup ./speederv2_amd64 -s -l0.0.0.0:$udpspeederport -r127.0.0.1:$port -k "atrandys" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./server_linux_amd64 -c ./kcptun_server.json >kcptun.log 2>&1 &

#写入开机自启
myfile="/etc/rc.d/init.d/kcpandudp"
if [ ! -f "$myfile" ]; then
cat > /etc/rc.d/init.d/kcpandudp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:kcpandudp
cd /usr/src/$yourdir
nohup ./speederv2_amd64 -s -l0.0.0.0:$udpspeederport -r127.0.0.1:$port -k "atrandys" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./server_linux_amd64 -c ./kcptun_server.json >kcptun.log 2>&1 &
EOF

chmod +x /etc/rc.d/init.d/kcpandudp
chkconfig --add kcpandudp
chkconfig kcpandudp on
else 
cat >> /etc/rc.d/init.d/kcpandudp<<-EOF
cd /usr/src/$yourdir
nohup ./speederv2_amd64 -s -l0.0.0.0:$udpspeederport -r127.0.0.1:$port -k "atrandys" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./server_linux_amd64 -c ./kcptun_server.json >kcptun.log 2>&1 &
EOF

fi
echo "安装完成"
else
echo "文件夹已存在"
fi

