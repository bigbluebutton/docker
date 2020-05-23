#!/bin/bash

#
# How N days back to keep files
#
history=5

while :
do
	# restart kurento after 24h
	/bbb-restart-kms
	
	# resync freeswitch
	/bbb-resync-freeswitch

	# delete presentations older than N days
	find /var/bigbluebutton/ -maxdepth 1 -type d -name "*-*" -mtime +$history -exec rm -rf '{}' +

	sleep 30m
done