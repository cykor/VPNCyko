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
将这上面这一行加到[路由器JFFS管理界面](http://192.168.1.1/admin-jffs2.asp)的Execute When Mounted中，这样路由器每次mount jffs的时候都会自动加载/opt

	cd /opt
	wget http://wl500g-repo.googlecode.com/svn/ipkg/entware_install.sh
	chmod +x ./entware_install.sh
	./entware_install.sh

#安装所需部件
	opkg install vpnc
	opkg install git
	opkg install python

#生成chnroutes
	mkdir /jffs/vpnc
	cd /jffs/vpnc
	git clone https://github.com/jimmyxu/chnroutes.git
	cd /jffs/vpnc/chnroutes
	python chnroutes.py

最后一步是将vpn-up.sh和vpn-down.sh中的`\#!bash`改为`#!sh`，这样就可以直接运行了；另外将vpn-up.sh中获取直连网关的代码改为：`OLDGW=$(nvram get wan_gateway_get) `，我觉得这样更直接一些。

#配置VPNC
通过opkg安装vpnc有个问题，就是没有vpnc-script。可以下载本项目中的vpnc-script，将文件中所有的`/etc/resolv.conf`全部替换成`/tmp/resolv.conf.auto`，之后放到*/opt/etc/vpnc/*目录下。请注意为vpnc-script加上可执行权限：

	chmod a+x vpnc-script

另外，在[@Paveo的blog](http://w3.owind.com/pub/page/4/)中下载修改过的vpncwatch，放到*/opt/sbin/*目录下（也需要可执行权限）。

#配置IPSec VPN账号
修改/opt/etc/vpnc/default.conf，或新建一个.conf，内容如下：

	IPSec gateway 服务器地址
	IPSec ID 服务商提供的组ID
	IPSec secret 服务商提供的组密码
	Xauth username 你的用户名
	Xauth password 你的密码

#最后的准备！
在[路由器脚本管理界面](http://192.168.1.1/admin-scripts.asp)的WAN Up中加入

	/jffs/vpnc/vpnup.sh;

指定路由器在外网链接建立后运行我们vpn脚本。
