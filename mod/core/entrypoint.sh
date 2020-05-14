#!/bin/bash

# print logs to stdout/stderr as soon as systemd is started
sh -c 'sleep 5 && journalctl -f' &

# generate bbb folders
mkdir -p /var/bigbluebutton/recording/raw
mkdir -p /var/bigbluebutton/recording/process
mkdir -p /var/bigbluebutton/recording/publish
mkdir -p /var/bigbluebutton/recording/status/recorded
mkdir -p /var/bigbluebutton/recording/status/archived
mkdir -p /var/bigbluebutton/recording/status/processed
mkdir -p /var/bigbluebutton/recording/status/sanity
mkdir -p /var/bigbluebutton/published
mkdir -p /var/bigbluebutton/deleted
mkdir -p /var/bigbluebutton/unpublished


dockerize \
    -template /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties \
    -template /usr/share/bbb-apps-akka/conf/application.conf.tmpl:/usr/share/bbb-apps-akka/conf/application.conf \
    /bin/systemd --system --unit=multi-user.target