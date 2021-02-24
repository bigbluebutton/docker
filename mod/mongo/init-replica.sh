#!/bin/sh
set -e


host=${HOSTNAME:-$(hostname -f)}

# init replset with defaults
mongo local --eval "rs.initiate({
   _id: 'rs0',
   members: [ { _id: 0, host: '127.0.0.1:27017' } ]
})"

echo "Waiting to become a master"
echo 'while (!db.isMaster().ismaster) { sleep(100); }' | mongo

echo "I'm the master!"