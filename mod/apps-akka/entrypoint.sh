#!/bin/sh -e

TARGET=/etc/bigbluebutton/bbb-apps-akka.conf
cp /etc/bigbluebutton/bbb-apps-akka.conf.tmpl $TARGET
sed -i "s/DOMAIN/$DOMAIN/" $TARGET
sed -i "s/SHARED_SECRET/$SHARED_SECRET/" $TARGET

cd /bbb-apps-akka
/bbb-apps-akka/bin/bbb-apps-akka