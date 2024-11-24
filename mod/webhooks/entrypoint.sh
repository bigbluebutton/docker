#!/bin/sh
set -e
TARGET=/bbb-webhooks/config/production.yml
cp /bbb-webhooks/config/default.example.yml $TARGET

yq e -i ".hooks.getRaw = false" $TARGET
yq e -i  '.modules."../out/webhooks/index.js".config.getRaw = false' $TARGET

export NODE_ENV=production
export REDIS_HOST=redis
export SERVER_DOMAIN=$DOMAIN
export BEARER_AUTH=true
export SERVER_BIND_IP=0.0.0.0

cd /bbb-webhooks
node app.js

