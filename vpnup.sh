#!/bin/sh

#Start VPNC
vpncwatch -c twitter.com -p 80 -i 30 vpnc /opt/etc/vpnc/igssh.conf
#chnroutes
/jffs/vpnc/chnroutes/vpn-up.sh

#prepare for novpn
mkdir /etc/iproute2
cp /jffs/vpnc/rt_tables /etc/iproute2/rt_tables
ip rule add from 192.168.1.33 table novpn
ip route add $(nvram get wan_gateway_get) dev ppp0 proto kernel scope link src $(nvram get wan_ipaddr) table novpn
ip route add 192.168.1.0/24 dev br0 proto kernel scope link src 192.168.1.1 table novpn
#IMDB
ip route add 72.21.206.80 dev tun0 scope link table novpn
ip route add 72.21.210.29 dev tun0 scope link table novpn
ip route add 207.171.166.22 dev tun0 scope link table novpn
#TVDB
ip route add 63.156.206.48 dev tun0 scope link table novpn
#Google
ip route add 8.8.8.8 dev tun0 scope link table novpn
ip route add 8.8.4.4 dev tun0 scope link table novpn
ip route add 72.14.192.0/18 dev tun0 scope link table novpn
ip route add 74.125.0.0/16 dev tun0 scope link table novpn
ip route add 72.14.203.132 dev tun0 scope link table novpn
ip route add 78.16.49.15 dev tun0 scope link table novpn
#DropBox
ip route add 174.36.30.0/24 dev tun0 scope link table novpn
ip route add 184.73.0.0/16 dev tun0 scope link table novpn
ip route add 174.129.20/24 dev tun0 scope link table novpn
ip route add 75.101.159.0/24 dev tun0 scope link table novpn
ip route add 75.101.140.0/24 dev tun0 scope link table novpn
ip route add 174.36.51.41 dev tun0 scope link table novpn
#PirateBay
ip route add 194.71.107.15 dev tun0 scope link table novpn
#default
ip route add default via $(nvram get wan_gateway_get) dev ppp0 table novpn
ip route flush cache


