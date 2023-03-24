#!/bin/bash -e

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

mkdir -p /var/freeswitch/meetings
chown -R freeswitch:daemon /var/freeswitch/meetings
chmod 777 /var/freeswitch/meetings
chown -R freeswitch:daemon /opt/freeswitch/var
chown -R freeswitch:daemon /opt/freeswitch/etc
chmod -R g-rwx,o-rwx /opt/freeswitch/etc

# install freeswitch sounds if missing
SOUNDS_DIR=/opt/freeswitch/share/freeswitch/sounds
if [ "$SOUNDS_LANGUAGE" == "en-us-callie" ]; then
    # default, is already installed
    echo ""
elif [ "$SOUNDS_LANGUAGE" == "de-de-daedalus3" ]; then
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
    if [ ! -f $SOUNDS_DIR/$SOUNDS_LANGUAGE.installed ]; then
        echo "sounds package for $SOUNDS_LANGUAGE not installed yet"
        
        # get filename of latest release for this sound package
        FILENAME=$(curl -s https://files.freeswitch.org/releases/sounds/ | grep -i $SOUNDS_LANGUAGE 2> /dev/null | awk -F'\"' '{print $8}' | grep -E '\-48000-.*\.gz$' | sort -V | tail -n 1)

        if [ "$FILENAME" = "" ]; then
            echo "Error: could not find sounds for language '$SOUNDS_LANGUAGE'"
            echo "make sure to specify a value for SOUNDS_LANGUAGE which exists on https://files.freeswitch.org/releases/sounds/"
            exit 1
        fi
        for bitrate in 8000 16000 32000 48000; do
            URL=https://files.freeswitch.org/releases/sounds/$(echo $FILENAME | sed "s/48000/$bitrate/")
            wget -O /tmp/sounds.tar.gz $URL
            tar xvfz /tmp/sounds.tar.gz -C $SOUNDS_DIR
        done

        touch $SOUNDS_DIR/$SOUNDS_LANGUAGE.installed
    fi
fi


export SOUNDS_PATH=$SOUNDS_DIR/$(echo "$SOUNDS_LANGUAGE" | sed 's|-|/|g')

dockerize \
    -template /etc/freeswitch/vars.xml.tmpl:/etc/freeswitch/vars.xml \
    -template /etc/freeswitch/autoload_configs/conference.conf.xml.tmpl:/etc/freeswitch/autoload_configs/conference.conf.xml \
    /opt/freeswitch/bin/freeswitch -u freeswitch -g daemon -nonat -nf
