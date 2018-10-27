# kcptun&udpspeeder
> 分别加速tcp和udp，适合某些在openvpn/wireguard+udpspeeder全局加速tcp、udp方案中表现不好的游戏。
### 注意
这里的方案配置的参数只适合游戏等小流量、低延迟需求的场景，不适合其他大流量使用场景，例如在线视频等。
### 服务端
服务端这里配置一个一键脚本，mix_server.sh，安装完成后服务开启自启动。
### 客户端
客户端也制作了bat脚本，start.bat、stop.bat，分别在开启时使用和关闭时使用。
udpspeeder和kcptun客户端监听同一个端口9898，此时tcp会进入kcptun隧道，udp会进入udpspeeder隧道。
### 搭配其他软件
这里我们只部署kcptun的加速隧道、udpspeeder的加速隧道，需要你在通道两端自行串联软件。
一个例子：客户端使用sstap、sockscap等软件，指向ss客户端，ss客户端指向本地9898端口（kcptun和udpspeeder客户端监听端口），服务端kcptun和udpspeeder指向ss服务端监听端口。
