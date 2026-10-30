ARG FREESWITCH_VERSION 1.11.3
FROM safarov/freeswitch:$FREESWITCH_VERSION

# pre download sounds
RUN wget https://files.freeswitch.org/freeswitch-sounds-en-us-callie-8000-1.0.51.tar.gz && \
    echo "freeswitch-sounds-en-us-callie-8000-1.0.51.tar.gz" >>  /usr/share/freeswitch/sounds/soundfiles_present.txt \
    wget https://files.freeswitch.org/freeswitch-sounds-en-us-callie-16000-1.0.51.tar.gz && \
    echo "freeswitch-sounds-en-us-callie-16000-1.0.51.tar.gz" >>  /usr/share/freeswitch/sounds/soundfiles_present.txt

# remove unnecessary profiles
RUN rm -rf /usr/share/freeswitch/conf/vanilla/sip_profiles/*-ipv6* \
    /usr/share/freeswitch/conf/vanilla/sip_profiles/internal*

# event socket only locally
RUN sed -i 's|"::"|"127.0.0.1"|' /usr/share/freeswitch/conf/vanilla/autoload_configs/event_socket.conf.xml

# disable not required modules
COPY modules.conf.xml /usr/share/freeswitch/conf/vanilla/autoload_configs/modules.conf.xml

# dialin
COPY livekit.xml /usr/share/freeswitch/conf/vanilla/sip_profiles/livekit.xml
COPY dialin.xml /usr/share/freeswitch/conf/vanilla/dialplan/public/dialin.xml
