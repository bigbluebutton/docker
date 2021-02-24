#!/bin/bash
set -e

# forward libreoffice ports to this container
for i in `seq 1 4` ; do
    let PORT=8200+${i}
    echo "forward port $PORT to the libreoffice container"
    socat TCP-LISTEN:$PORT,fork TCP:10.7.7.7:$PORT &
done

# create recording directory structure if it doesn't exist yet
mkdir -p /var/bigbluebutton/recording/raw
mkdir -p /var/bigbluebutton/recording/process
mkdir -p /var/bigbluebutton/recording/publish
mkdir -p /var/bigbluebutton/recording/status/recorded
mkdir -p /var/bigbluebutton/recording/status/archived
mkdir -p /var/bigbluebutton/recording/status/processed
mkdir -p /var/bigbluebutton/recording/status/sanity
mkdir -p /var/bigbluebutton/recording/status/ended
mkdir -p /var/bigbluebutton/recording/status/published
mkdir -p /var/bigbluebutton/captions/inbox
mkdir -p /var/bigbluebutton/published
mkdir -p /var/bigbluebutton/deleted
mkdir -p /var/bigbluebutton/unpublished
chown -R bigbluebutton:bigbluebutton /var/bigbluebutton

echo "$NUMBER_OF_BACKEND_NODEJS_PROCESSES" > /tmp/NUMBER_OF_BACKEND_NODEJS_PROCESSES

cd /usr/share/bbb-web/
dockerize \
    -template /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties \
    -template /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl:/usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml \
    gosu bigbluebutton java -Dgrails.env=prod -Dserver.address=0.0.0.0 -Dserver.port=8090 -Xms384m -Xmx384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/bigbluebutton/diagnostics -cp WEB-INF/lib/*:/:WEB-INF/classes/:. org.springframework.boot.loader.WarLauncher


