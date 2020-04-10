#!/bin/bash

# print logs to stdout/stderr as soon as systemd is started
sh -c 'sleep 5 && journalctl -f' &

dockerize \
    -template /opt/freeswitch/conf/vars.xml.tmpl:/opt/freeswitch/conf/vars.xml \
    -template /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties \
    -template /usr/share/bbb-apps-akka/conf/application.conf.tmpl:/usr/share/bbb-apps-akka/conf/application.conf \
    /bin/systemd --system --unit=multi-user.target