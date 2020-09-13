#!/bin/bash

# print all logs to stdout
python3 -u /log-collector.py &

cd /usr/local/bigbluebutton/core/scripts
PATH_CHECK="/var/bigbluebutton/recording/status"
while true; do
    echo "execute workers..."
    if [[ $(compgen -G "$PATH_CHECK/recorded/*.done") ]];then
    bundle exec ruby rap-archive-worker.rb
    fi
    if [[ $(compgen -G "$PATH_CHECK/archived/*.done") ]];then
    bundle exec ruby rap-sanity-worker.rb
    fi
    if [[ $(compgen -G "$PATH_CHECK/sanity/*.done") ]];then
    bundle exec ruby rap-process-worker.rb
    fi
    if [[ $(compgen -G "$PATH_CHECK/processed/*.done") ]];then
    bundle exec ruby rap-publish-worker.rb
    fi
    #bundle exec ruby rap-caption-inbox.rb
    if [[ $(compgen -G "$PATH_CHECK/ended/*.done") ]];then
    bundle exec ruby rap-events-worker.rb
    fi
    sleep 30s
done
