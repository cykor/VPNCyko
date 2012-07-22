#!/bin/sh

/jffs/vpnc/chnroutes/chnroutes.py
sed -i 's/bash.*$/sh/' vpn-up.sh
sed -i 's/\$(.*/\$(nvram get wan_gateway_get)/' vpn-up.sh

