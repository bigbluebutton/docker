#!/bin/bash -ex


HOST=meet.livingutopia.org
TOMCAT_USER=tomcat7
SERVLET_DIR=/usr/share/bbb-web

TURN_XML=$SERVLET_DIR/WEB-INF/classes/spring/turn-stun-servers.xml

while [ ! -f $SERVLET_DIR/WEB-INF/classes/bigbluebutton.properties ]; do sleep 1; echo -n '.'; done

# delete IPv6 sip profiles
rm -rf /opt/freeswitch/conf/sip_profiles/*-ipv6*


if [ -f /var/www/bigbluebutton/client/conf/config.xml ]; then
  sed -i 's/offerWebRTC="false"/offerWebRTC="true"/g' /var/www/bigbluebutton/client/conf/config.xml
fi

# while [ ! -f /var/lib/$TOMCAT_USER/webapps/demo/bbb_api_conf.jsp ]; do sleep 1; echo -n '.'; done


if [ -f /var/www/bigbluebutton/client/conf/config.xml ]; then
  sed -i 's/tryWebRTCFirst="false"/tryWebRTCFirst="true"/g' /var/www/bigbluebutton/client/conf/config.xml
fi

rm -f /etc/nginx/sites-enabled/default

if [ -f /var/www/bigbluebutton/client/conf/config.xml ]; then
  sed -i 's|http://|https://|g' /var/www/bigbluebutton/client/conf/config.xml
  sed -i 's/jnlpUrl=http/jnlpUrl=https/g'   /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties
  sed -i 's/jnlpFile=http/jnlpFile=https/g' /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties
fi 

yq w -i /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml playback_protocol https
chmod 644 /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml 

# if [ -f /var/lib/$TOMCAT_USER/webapps/demo/bbb_api_conf.jsp ]; then
#   sed -i 's|String BigBlueButtonURL = ".*|String BigBlueButtonURL = "http://127.0.0.1:8090/bigbluebutton/";|g' /var/lib/$TOMCAT_USER/webapps/demo/bbb_api_conf.jsp
# fi

# Update HTML5 client (if installed) to use SSL
if [ -f  /usr/share/meteor/bundle/programs/server/assets/app/config/settings.json ]; then
  sed -i "s|\"wsUrl.*|\"wsUrl\": \"wss://$HOST/bbb-webrtc-sfu\",|g" \
    /usr/share/meteor/bundle/programs/server/assets/app/config/settings.json
fi

bbb-conf --setip $HOST
# Assigning meet.livingutopia.org for testing for firewall in /var/www/bigbluebutton/client/conf/config.xml
# Assigning meet.livingutopia.org for rtmp:// in /var/www/bigbluebutton/client/conf/config.xml
# Assigning meet.livingutopia.org for servername in /etc/nginx/sites-available/bigbluebutton
# Assigning meet.livingutopia.org for http[s]:// in /var/www/bigbluebutton/client/conf/config.xml
# Assigning meet.livingutopia.org for publishURI in /var/www/bigbluebutton/client/conf/config.xml
# Assigning meet.livingutopia.org for web application URL in /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# sed: cannot rename /usr/share/bbb-web/WEB-INF/classes/sed3ZgbUO: Device or resource busy
# sed: cannot rename /usr/share/bbb-web/WEB-INF/classes/sednkGxuN: Device or resource busy
# Assigning meet.livingutopia.org for web application URL in /usr/share/bbb-apps-akka/conf/application.conf 
# Assigning meet.livingutopia.org for api demos in /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Assigning meet.livingutopia.org for record and playback in /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml
# Assigning meet.livingutopia.org for playback of recordings:         

# Disable auto start 
find /etc/systemd/ | grep wants | xargs -r -n 1 basename | grep service | grep -v networking | grep -v tty   | xargs -r -n 1 -I __ systemctl disable __
systemctl disable tomcat7

# Update files
updatedb
