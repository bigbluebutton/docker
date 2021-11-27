#!/bin/bash

touch /var/log/bigbluebutton/recording.log
touch /var/log/bigbluebutton/bbb-web.log
mkdir -p /var/log/bigbluebutton/presentation
chown -R bigbluebutton:bigbluebutton /var/log/bigbluebutton

dockerize \
    -template /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml.tmpl:/usr/local/bigbluebutton/core/scripts/bigbluebutton.yml \
    -template /etc/bigbluebutton/bbb-web.properties.tmpl:/etc/bigbluebutton/bbb-web.properties \
    -stdout /var/log/bigbluebutton/recording.log \
    /usr/bin/supervisord --nodaemon