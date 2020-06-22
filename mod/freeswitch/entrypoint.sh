#!/bin/bash

# remove all SIP (port 5060) iptable rules
iptables -S INPUT | grep "\-\-dport 5060 " | cut -d " " -f 2- | xargs -rL1 iptables -D

# block requests to 5060 (tcp/udp)
iptables -A INPUT -i "$NETWORK_INTERFACE" -p tcp --dport 5060 -s 0.0.0.0/0 -j REJECT
iptables -A INPUT -i "$NETWORK_INTERFACE" -p udp --dport 5060 -s 0.0.0.0/0 -j REJECT

# allow some IPs 
IFS=',' read -ra ADDR <<< "$SIP_IP_ALLOWLIST"
for IP in "${ADDR[@]}"; do
    # process "$i"
    echo "allow port 5060/udp for $IP"
    iptables -I INPUT  -p udp --dport 5060 -s $IP -j ACCEPT
done

dockerize \
    -template /etc/freeswitch/vars.xml.tmpl:/etc/freeswitch/vars.xml \
    /usr/bin/freeswitch -u freeswitch -g daemon -nonat -nf
