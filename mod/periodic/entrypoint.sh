#!/bin/bash

#
# How N days back to keep files
#
history=5

while :
do

	# resync freeswitch
	/bbb-resync-freeswitch

	# delete presentations older than N days
	find /var/bigbluebutton/ -maxdepth 1 -type d -name "*-[0-9]*" -mtime +$history -exec rm -rf '{}' +

  # delete recordings older than $RECORDING_MAX_AGE_DAYS
  if [ "$ENABLE_RECORDING" == true ] && [ "$REMOVE_OLD_RECORDING" == true ]; then
    /bbb-remove-old-recordings
  fi

	sleep 30m
done
