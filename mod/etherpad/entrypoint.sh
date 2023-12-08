#!/bin/sh
echo $ETHERPAD_API_KEY > /tmp/apikey
export NODE_ENV=production

node /opt/etherpad-lite/node_modules/ep_etherpad-lite/node/server.js --apikey /tmp/apikey