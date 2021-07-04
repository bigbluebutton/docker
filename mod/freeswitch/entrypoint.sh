#!/bin/bash

# remove all SIP (port 5060) iptable rules
iptables -S INPUT | grep "\-\-dport 5060 " | cut -d " " -f 2- | xargs -rL1 iptables -D

# block requests to 5060 (tcp/udp)
iptables -A INPUT -p tcp --dport 5060 -s 0.0.0.0/0 -j REJECT
iptables -A INPUT -p udp --dport 5060 -s 0.0.0.0/0 -j REJECT

# allow some IPs 
IFS=',' read -ra ADDR <<< "$SIP_IP_ALLOWLIST"
for IP in "${ADDR[@]}"; do
    # process "$i"
    echo "allow port 5060/udp for $IP"
    iptables -I INPUT  -p udp --dport 5060 -s $IP -j ACCEPT
done

chown -R freeswitch:daemon /var/freeswitch/meetings
chmod 777 /var/freeswitch/meetings


# install freeswitch sounds if missing
SOUNDS_DIR=/usr/share/freeswitch/sounds
if [ "$SOUNDS_LANGUAGE" == "de-de-daedalus3" ]; then
    if [ ! -d "$SOUNDS_DIR/de/de/daedalus3" ]; then
        echo "sounds package for de-de-daedalus3 not installed yet"
        wget -O /tmp/freeswitch-german-soundfiles.zip https://github.com/Daedalus3/freeswitch-german-soundfiles/archive/master.zip
        mkdir -p $SOUNDS_DIR/de/de/daedalus3
        unzip /tmp/freeswitch-german-soundfiles.zip -d /tmp/
        mv /tmp/freeswitch-german-soundfiles-master $SOUNDS_DIR/de/de/daedalus3/conference

        # symlink other folders
        for folder in "digits" "ivr" "misc"; do
            ln -s $SOUNDS_DIR/en/us/callie/$folder $SOUNDS_DIR/de/de/daedalus3/$folder
        done

    fi
else
    SOUNDS_PACKAGE=$(echo "freeswitch-sounds-${SOUNDS_LANGUAGE}" | tr '[:upper:]' '[:lower:]')
    if ! dpkg -s $SOUNDS_PACKAGE >/dev/null 2>&1; then
        echo "sounds package for $SOUNDS_LANGUAGE not installed yet"
        apt-get install $SOUNDS_PACKAGE
    fi
fi


export SOUNDS_PATH=$SOUNDS_DIR/$(echo "$SOUNDS_LANGUAGE" | sed 's|-|/|g')

dockerize \
    -template /etc/freeswitch/vars.xml.tmpl:/etc/freeswitch/vars.xml \
    -template /etc/freeswitch/autoload_configs/conference.conf.xml.tmpl:/etc/freeswitch/autoload_configs/conference.conf.xml \
    /usr/bin/freeswitch -u freeswitch -g daemon -nonat -nf
