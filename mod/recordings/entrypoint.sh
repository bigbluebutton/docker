#!/bin/bash

# print all logs to stdout
python3 -u /log-collector.py &

cd /usr/local/bigbluebutton/core/scripts

while true; do
    echo "execute workers..."
    bundle exec ruby rap-archive-worker.rb
    bundle exec ruby rap-sanity-worker.rb
    bundle exec ruby rap-process-worker.rb
    bundle exec ruby rap-publish-worker.rb

    bundle exec ruby rap-caption-inbox.rb
    bundle exec ruby rap-events-worker.rb

    sleep 30s