#!/bin/bash

#必要的工具
yum -y install wget

#下载几个配置文件
mkdir /usr/src/game
mkdir /usr/src/game/client
cd /usr/src/game/client
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/start.bat
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/stop.bat
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/kcptun_client.json
cd /usr/src/game
wget https://raw.githubusercontent.com/yobabyshark/kcptun_and_udpspeeder/master/kcptun_server.json
wget https://github.com/yobabyshark/kcptun_and_udpspeeder/raw/master/speederv2_amd64
wget https://github.com/yobabyshark/kcptun_and_udpspeeder/raw/master/server_linux_amd64
chmod +x speederv2_amd64 server_linux_amd64

#设置参数
serverip=$(curl icanhazip.com)
echo "输入本地代理软件监听的端口"
read -p "请输入数字:" port
sed -i "s/your_server_ip/$serverip/" /usr/src/game/client/kcptun_client.json
sed -i "s/your_server_ip/$serverip/" /usr/src/game/client/start.bat
sed -i "s/your_server_port/$port/" /usr/src/game/kcptun_server.json

#启动服务
nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:$port -k "atrandys" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./server_linux_amd64 -c ./kcptun_server.json >kcptun.log 2>&1 &

#写入开机自启
cat > /etc/rc.d/init.d/kcpandudp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:kcpandudp
cd /usr/src/game
nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:$port -k "atrandys" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./server_linux_amd64 -c ./kcptun_server.json >kcptun.log 2>&1 &
EOF

chmod +x /etc/rc.d/init.d/kcpandudp

echo "安装完成"

