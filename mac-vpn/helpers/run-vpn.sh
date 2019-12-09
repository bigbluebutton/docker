#!/bin/sh

dest=${dest:-docker.ovpn}

if [ ! -f "/local/$dest" ]; then
    echo "*** REGENERATING ALL CONFIGS ***"
    set -ex
    #rm -rf /etc/openvpn/*
    ovpn_genconfig -u tcp://localhost
    sed -i 's|^push|#push|' /etc/openvpn/openvpn.conf
    echo localhost | ovpn_initpki nopass
    easyrsa build-client-full host nopass
    ovpn_getclient host | sed '
    	s|localhost 1194|localhost 13194|;
	s|redirect-gateway.*|route 172.16.0.0 255.240.0.0|;
    ' > "/local/$dest"
fi

# Workaround for https://github.com/wojas/docker-mac-network/issues/6
/sbin/iptables -I FORWARD 1 -i tun+ -j ACCEPT

exec ovpn_run
