本项目记录了我在自己家里的路由器上设置科学上网的全过程，供有类似需求的朋友参考。本项目基于以下配置：

* 路由器：[华硕RT-N16](http://www.asus.com/Networks/Wireless_Routers/RTN16/)，一款性价比较高的路由器，配置不错，特别是拥有32MB Flash，所以也是很多固件开发者的开发用机，可用的ROM非常多
* 固件：[Tomato by Shibby](http://tomato.groov.pl/)，目前使用的版本是[K26USB-1.28.RT-N5x-MIPSR2-095-AIO](http://tomato.groov.pl/download/K26RT-N/build5x-095-EN/)
* VPN：[IGVPN](https://www.igssh.com/)的[Pro Bundle](https://www.igssh.com/cart.php)，45GB/月3台并发，支持几乎现在流行的所有设备的所有接入方式，服务器多、速度快、文档详尽，一年360元算是物有所值了。我是用的是香港的Cisco IPSec服务器。
* 宽带：我家用的是长城宽带……

#参考文档
* [\[BLT\]FQX的Blog](http://www.zhongguotese.net)，本项目赤裸裸抄袭了[这篇文章](http://www.zhongguotese.net/2012/a-bridge-to-home-theater-2.html)和其中的代码
* [@Paveo的blog](http://w3.owind.com)，作为一个Falcop用户，虽然买不起VIG，但是向你致敬
* [jimmyxu的chnroutes项目](https://github.com/jimmyxu/chnroutes)

#通过ssh访问路由器
在Terminal中：

	ssh-keygen
	cat ~/.ssh/id_rsa.public
将id_rsa.public中的内容拷贝到[路由器访问管理界面](http://192.168.1.1/admin-access.asp)的Authorized Keys中，之后在Terminal中：

	ssh root@192.168.1.1

就可以登陆路由器了

#通过ssh登陆，安装opkg
	mkdir /jffs/opt
	mount -o bind /jffs/opt /opt 
将这上面这一行加到[路由器JFFS管理界面](http://192.168.1.1/admin-jffs2.asp)的Execute When Mounted中，这样路由器每次mount jffs的时候都会自动加载*/opt*

	cd /opt
	wget http://wl500g-repo.googlecode.com/svn/ipkg/entware_install.sh
	chmod +x ./entware_install.sh
	./entware_install.sh

#安装并生成chnroutes
如果路由器的Flash空间不够，可以跳过本步，直接下载文档中的vpn-up.sh，放到*/opt/etc/vpnc/*目录下。不过如果空间允许，还是建议安装，便于以后升级更新。

	opkg install git
	opkg install python
	mkdir /jffs/vpnc
	cd /jffs/vpnc
	git clone https://github.com/jimmyxu/chnroutes.git
	cd /jffs/vpnc/chnroutes
	python chnroutes.py
	……待补充

最后一步是将vpn-up.sh和vpn-down.sh中的`\#!bash`改为`#!sh`，这样就可以直接运行了；另外将vpn-up.sh中获取直连网关的代码改为：`OLDGW=$(nvram get wan_gateway_get) `，我觉得这样更直接一些。

#安装VPNC
首先安装vpnc。用ipkg安装似乎存在依赖的问题，另外ipkg里面的vpnc版本要比opkg的老一个revision，所以用opkg安装：

	opkg install vpnc
	
但是通过opkg安装vpnc有个问题，就是没有vpnc-script。可以下载本项目中的vpnc-script，将文件中所有的`/etc/resolv.conf`全部替换成`/tmp/resolv.conf.auto`，之后放到*/opt/etc/vpnc/*目录下。请注意为vpnc-script加上可执行权限：

	chmod a+x vpnc-script

另外，在[@Paveo的blog](http://w3.owind.com/pub/page/4/)中下载修改过的vpncwatch，放到*/opt/sbin/*目录下（也需要可执行权限）。

#配置IPSec VPN账号
修改/opt/etc/vpnc/default.conf，或新建一个.conf，内容如下：

	IPSec gateway 服务器地址
	IPSec ID 服务商提供的组ID
	IPSec secret 服务商提供的组密码
	Xauth username 你的用户名
	Xauth password 你的密码

#最后的准备
在[路由器脚本管理界面](http://192.168.1.1/admin-scripts.asp)的WAN Up中加入

	/jffs/vpnc/vpnup.sh;

告诉路由器在外网链接建立后运行我们vpn脚本。

虽然并不必要，但是**现在重启路由器吧**！享受大功告成的感觉！
