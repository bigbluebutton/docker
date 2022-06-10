#!/bin/sh -e

TARGET=/etc/bigbluebutton/bbb-fsesl-akka.conf

cp /etc/bigbluebutton/bbb-fsesl-akka.conf.tmpl $TARGET
sed -i "s/FSESL_PASSWORD/$FSESL_PASSWORD/" $TARGET

cd /bbb-fsesl-akka
/bbb-fsesl-akka/bin/bbb-fsesl-akka