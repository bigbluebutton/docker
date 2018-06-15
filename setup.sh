#!/bin/bash
set -x

change_var_value () {
        sed -i "s<^[[:blank:]#]*\(${2}\).*<\1=${3}<" $1
}

# docker build -t ffdixon/play_win .
# docker run -p 80:80/tcp -p 443:443/tcp -p 1935:1935/tcp -p 5066:5066/tcp -p 2202:2202 -p 32750-32768:32750-32768/udp --cap-add=NET_ADMIN ffdixon/play_win -h 192.168.0.130
# docker run -p 80:80/tcp -p 443:443/tcp -p 1935:1935/tcp -p 5066:5066/tcp -p 2202:2202 -p 32750-32768:32750-32768/udp --cap-add=NET_ADMIN ffdixon/play_win -h 192.168.10.186

while getopts "eh:" opt; do
  case $opt in
    e)
      env
      exit
      ;;
    h)
      HOST=$OPTARG
      ;;
    s)
      SECRET=$OPTARG
      ;;
    :) 
      echo "Missing option argument for -$OPTARG" >&2; 
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      cat<<HERE
Docker startup script for BigBlueButton.

  -h   Hostname for BigBlueButton server
  -s   Shared secret

HERE
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

apt-get install -y bbb-demo && /etc/init.d/tomcat7 start
while [ ! -f /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp ]; do sleep 1; done
sudo /etc/init.d/tomcat7 stop


# Setup loopback address so FreeSWITCH can bind WS-BIND-URL to host IP
#
sudo ip addr add $HOST dev lo

# Setup the BigBlueButton configuration files
#
PROTOCOL_HTTP=http
PROTOCOL_RTMP=rtmp
IP=$(echo "$(LANG=c ifconfig  | awk -v RS="" '{gsub (/\n[ ]*inet /," ")}1' | grep ^et.* | grep addr: | head -n1 | sed 's/.*addr://g' | sed 's/ .*//g')$(LANG=c ifconfig  | awk -v RS="" '{gsub (/\n[ ]*inet /," ")}1' | grep ^en.* | grep addr: | head -n1 | sed 's/.*addr://g' | sed 's/ .*//g')" | head -n1)

sed -i 's/<!-- <param name="rtp-start-port" value="16384"\/> -->/<param name="rtp-start-port" value="32750"\/>/g' /opt/freeswitch/etc/freeswitch/autoload_configs/switch.conf.xml
sed -i 's/<!-- <param name="rtp-end-port" value="32768"\/> -->/<param name="rtp-end-port" value="32768"\/>/g' /opt/freeswitch/etc/freeswitch/autoload_configs/switch.conf.xml

sed -i "s/stun:stun.freeswitch.org/$HOST/g" /opt/freeswitch/etc/freeswitch/vars.xml
sed -i "s/<X-PRE-PROCESS cmd=\"set\" data=\"local_ip_v4=.*//g" /opt/freeswitch/etc/freeswitch/vars.xml

sed -i "s/ext-rtp-ip\" value=\"\$\${local_ip_v4/ext-rtp-ip\" value=\"\$\${external_rtp_ip/g" /opt/freeswitch/conf/sip_profiles/external.xml
sed -i "s/ext-sip-ip\" value=\"\$\${local_ip_v4/ext-sip-ip\" value=\"\$\${external_sip_ip/g" /opt/freeswitch/conf/sip_profiles/external.xml
sed -i "s/<param name=\"ws-binding\".*/<param name=\"ws-binding\"  value=\"$HOST:5066\"\/>/g" /opt/freeswitch/conf/sip_profiles/external.xml

sed -i "s/proxy_pass .*/proxy_pass $PROTOCOL_HTTP:\/\/$HOST:5066;/g" /etc/bigbluebutton/nginx/sip.nginx

sed -i "s/porttest host=\(\"[^\"]*\"\)/porttest host=rtmp://\"$HOST\"/g" /var/www/bigbluebutton/client/conf/config.xml
sed -i "s/publishURI=\"[^\"]*\"/publishURI=\"$HOST\"/" /var/www/bigbluebutton/client/conf/config.xml
sed -i "s/http[s]*:\/\/\([^\"\/]*\)\([\"\/]\)/$PROTOCOL_HTTP:\/\/$HOST\2/g"  /var/www/bigbluebutton/client/conf/config.xml
sed -i "s/rtmp[s]*:\/\/\([^\"\/]*\)\([\"\/]\)/$PROTOCOL_RTMP:\/\/$HOST\2/g" /var/www/bigbluebutton/client/conf/config.xml

sed -i "s/server_name  .*/server_name  $HOST;/g" /etc/nginx/sites-available/bigbluebutton

sed -i "s/bigbluebutton.web.serverURL=http[s]*:\/\/.*/bigbluebutton.web.serverURL=$PROTOCOL_HTTP:\/\/$HOST/g" \
                        /var/lib/tomcat7/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties

change_var_value /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties streamBaseUrl rtmp://$HOST/screenshare
change_var_value /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties jnlpUrl $PROTOCOL_HTTP://$HOST/screenshare
change_var_value /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties jnlpFile $PROTOCOL_HTTP://$HOST/screenshare/screenshare.jnlp

change_var_value /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties bbb.sip.app.ip $IP
change_var_value /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties freeswitch.ip $IP

sed -i  "s/bbbWebAPI[ ]*=[ ]*\"[^\"]*\"/bbbWebAPI=\"${PROTOCOL_HTTP}:\/\/$HOST\/bigbluebutton\/api\"/g" \
	/usr/share/bbb-apps-akka/conf/application.conf
sed -i "s/bbbWebHost[ ]*=[ ]*\"[^\"]*\"/bbbWebHost=\"$HOST\"/g" \
	/usr/share/bbb-apps-akka/conf/application.conf
sed -i "s/deskshareip[ ]*=[ ]*\"[^\"]*\"/deskshareip=\"$HOST\"/g" \
	/usr/share/bbb-apps-akka/conf/application.conf
sed -i  "s/defaultPresentationURL[ ]*=[ ]*\"[^\"]*\"/defaultPresentationURL=\"${PROTOCOL_HTTP}:\/\/$HOST\/default.pdf\"/g" \
	/usr/share/bbb-apps-akka/conf/application.conf

# Fix to ensure application.conf has the latest shared secret
SECRET=$(cat /var/lib/tomcat7/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties | grep -v '#' | grep securitySalt | cut -d= -f2);
sed -i "s/sharedSecret[ ]*=[ ]*\"[^\"]*\"/sharedSecret=\"$SECRET\"/g" \
	/usr/share/bbb-apps-akka/conf/application.conf

sed -i "s/BigBlueButtonURL = \"http[s]*:\/\/\([^\"\/]*\)\([\"\/]\)/BigBlueButtonURL = \"$PROTOCOL_HTTP:\/\/$HOST\2/g" \
                        /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp

sed -i "s/playback_host: .*/playback_host: $HOST/g" /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml

sed -i 's/daemonize no/daemonize yes/g' /etc/redis/redis.conf

rm /usr/share/red5/log/sip.log

# Add a sleep to each recording process so we can restart with supervisord
sed -i 's/BigBlueButton.logger.debug("rap-archive-worker done")/sleep 20; BigBlueButton.logger.debug("rap-archive-worker done")/g' /usr/local/bigbluebutton/core/scripts/rap-archive-worker.rb

sed -i 's/BigBlueButton.logger.debug("rap-process-worker done")/sleep 20; BigBlueButton.logger.debug("rap-process-worker done")/g' /usr/local/bigbluebutton/core/scripts/rap-process-worker.rb

sed -i 's/BigBlueButton.logger.debug("rap-sanity-worker done")/sleep 20; BigBlueButton.logger.debug("rap-sanity-worker done")/g' /usr/local/bigbluebutton/core/scripts/rap-sanity-worker.rb

sed -i 's/BigBlueButton.logger.debug("rap-publish-worker done")/sleep 20; BigBlueButton.logger.debug("rap-publish-worker done")/g' /usr/local/bigbluebutton/core/scripts/rap-publish-worker.rb 

# Start BigBlueButton!
#
/usr/bin/supervisord

