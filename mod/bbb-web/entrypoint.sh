#!/bin/bash
set -e

# create recording directory structure if it doesn't exist yet
mkdir -p /var/bigbluebutton/recording/status
mkdir -p /var/bigbluebutton/events
mkdir -p /var/bigbluebutton/recording
mkdir -p /var/bigbluebutton/recording/raw
mkdir -p /var/bigbluebutton/recording/process
mkdir -p /var/bigbluebutton/recording/publish
mkdir -p /var/bigbluebutton/recording/status/recorded
mkdir -p /var/bigbluebutton/recording/status/archived
mkdir -p /var/bigbluebutton/recording/status/processed
mkdir -p /var/bigbluebutton/recording/status/ended
mkdir -p /var/bigbluebutton/recording/status/sanity
mkdir -p /var/bigbluebutton/recording/status/published
mkdir -p /var/bigbluebutton/captions
mkdir -p /var/bigbluebutton/captions/inbox
mkdir -p /var/bigbluebutton/published
mkdir -p /var/bigbluebutton/deleted
mkdir -p /var/bigbluebutton/unpublished
mkdir -p /var/bigbluebutton/basic_stats
chown -R bigbluebutton:bigbluebutton /var/bigbluebutton

cd /usr/share/bbb-web/
dockerize \
    -template /etc/bigbluebutton/bbb-web.properties.tmpl:/etc/bigbluebutton/bbb-web.docker.properties \
    -template /etc/bigbluebutton/turn-stun-servers.xml.tmpl:/etc/bigbluebutton/turn-stun-servers.xml

# concat mod/bbb-web/bbb-web.properties and conf/bbb-web.properties
cat \
    /etc/bigbluebutton/bbb-web.docker.properties \
    /etc/bigbluebutton/bbb-web.custom.properties \
> /etc/bigbluebutton/bbb-web.properties

gosu bigbluebutton java -Dgrails.env=prod -Dserver.address=0.0.0.0 -Dserver.port=8090 -Xms384m -Xmx384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/bigbluebutton/diagnostics -cp . org.springframework.boot.loader.launch.WarLauncher


