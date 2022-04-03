#!/bin/sh
set -e
TARGET=/bbb-webhooks/config/production.yml
cp /bbb-webhooks/config/default.example.yml $TARGET

yq e -i ".bbb.sharedSecret = \"$SHARED_SECRET\"" $TARGET
yq e -i ".bbb.serverDomain = \"$DOMAIN\"" $TARGET
yq e -i ".bbb.auth2_0 = true" $TARGET
yq e -i ".server.bind = \"0.0.0.0\"" $TARGET
yq e -i ".hooks.getRaw = false" $TARGET
yq e -i ".redis.host = \"redis\"" $TARGET

export NODE_ENV=production

cd /bbb-webhooks
node app.js

