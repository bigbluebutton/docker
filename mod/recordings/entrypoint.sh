#!/bin/bash

touch /var/log/bigbluebutton/recording.log
touch /var/log/bigbluebutton/bbb-web.log
touch /var/log/bigbluebutton/sanity.log
touch /var/log/bigbluebutton/post_publish.log
mkdir -p /var/log/bigbluebutton/presentation
chown -R bigbluebutton:bigbluebutton /var/log/bigbluebutton

dockerize \
    -template /etc/bigbluebutton/recording/recording.yml.tmpl:/etc/bigbluebutton/recording/recording.yml \
    -template /etc/bigbluebutton/bbb-web.properties.tmpl:/etc/bigbluebutton/bbb-web.properties \
    -stdout /var/log/bigbluebutton/recording.log \
    -stdout /var/log/bigbluebutton/post_publish.log \
    -stdout /var/log/bigbluebutton/sanity.log \
    /usr/bin/supervisord --nodaemon