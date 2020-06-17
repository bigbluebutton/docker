#!/bin/bash

# /var/bigbluebutton/recording/status/processed/*.done  -> publish-worker.rb
# /var/bigbluebutton/recording/status/sanity/*.done  -> process-worker
# /var/bigbluebutton/recording/status/ended/*.done -> events-worker
# /var/bigbluebutton/recording/status/recorded/*.done -> archive-worker
# /var/bigbluebutton/recording/status/archived/*.done -> sanity-worker

FILES_TO_CHECK=$1

PATH_TO_CHECK="/var/bigbluebutton/recording/status"
CMD_DIR_PATH="/usr/local/bigbluebutton/core/scripts"

function do_monitoring() {
  while ! compgen -G "$PATH_TO_CHECK" > /dev/null; do
    echo "$PATH_TO_CHECK returning 0 files, sleeping for 30s..."
    sleep 30
  done
  if [[ -d "$CMD_DIR_PATH" ]]; then
    pushd $CMD_DIR_PATH > /dev/null
    ruby $CMD_PATH
    popd > /dev/null
  fi
  sleep 5
  echo "Re-monitoring files.."
  do_monitoring
}

function initialize_variables() {
  echo "$FILES_TO_CHECK"
  if [[ ! -z $FILES_TO_CHECK ]]; then
    if [[ $FILES_TO_CHECK == "processed" ]]; then
      PATH_TO_CHECK="$PATH_TO_CHECK/processed/*.done"
      CMD_PATH="/usr/local/bigbluebutton/core/scripts/rap-publish-worker.rb"
    elif [[ $FILES_TO_CHECK == "sanity" ]]; then
      PATH_TO_CHECK="$PATH_TO_CHECK/sanity/*.done"
      CMD_PATH="/usr/local/bigbluebutton/core/scripts/rap-process-worker.rb"
    elif [[ $FILES_TO_CHECK == "ended" ]]; then
      PATH_TO_CHECK="$PATH_TO_CHECK/ended/*.done"
      CMD_PATH="/usr/local/bigbluebutton/core/scripts/rap-events-worker.rb"
    elif [[ $FILES_TO_CHECK == "recorded" ]]; then
      PATH_TO_CHECK="$PATH_TO_CHECK/recorded/*.done"
      CMD_PATH="/usr/local/bigbluebutton/core/scripts/rap-archive-worker.rb"
    elif [[ $FILES_TO_CHECK == "archived" ]]; then
      PATH_TO_CHECK="$PATH_TO_CHECK/archived/*.done"
      CMD_PATH="/usr/local/bigbluebutton/core/scripts/rap-sanity-worker.rb"
    else
      echo "invalid argument, exiting..."
      exit
    fi
  else
    echo "invalid argument, exiting..."
    exit
  fi
}

# first check variables
initialize_variables
# main execution
do_monitoring
