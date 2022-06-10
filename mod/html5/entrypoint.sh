#!/bin/sh
set -e

cd /app
export MONGO_OPLOG_URL=mongodb://10.7.7.6/local
export MONGO_URL=mongodb://10.7.7.6/meteor
export ROOT_URL=http://127.0.0.1/html5client
export NODE_ENV=production
export SERVER_WEBSOCKET_COMPRESSION=0
export BIND_IP=0.0.0.0
export LANG=en_US.UTF-8
export INSTANCE_MAX=1
export ENVIRONMENT_TYPE=production
export NODE_VERSION=node-v14.19.1-linux-x64
export BBB_HTML5_LOCAL_SETTINGS=/app/bbb-html5.yml

if [ "$DEV_MODE" == true ]; then
    echo "DEV_MODE=true, disable TLS certificate rejecting"
    export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

if [ "$BBB_HTML5_ROLE" == "backend" ]; then
    PARAM=NODEJS_BACKEND_INSTANCE_ID=$INSTANCE_ID
fi


# if container is the first frontend, do some additional tasks
if [ "$BBB_HTML5_ROLE" == "frontend" ] && [ "$INSTANCE_ID" == "1" ]; then


    # copy static files into volume for direct access by nginx
    # https://github.com/bigbluebutton/bigbluebutton/issues/10739
    if [ -d "/html5-static" ]; then
        rm -rf /html5-static/*
        cp -r /app/programs/web.browser/* /html5-static
    fi

fi

dockerize \
    -template /app/bbb-html5.yml.tmpl:/app/bbb-html5.yml \
    su-exec meteor \
        node --max-old-space-size=2048 --max_semi_space_size=128 main.js $PARAM
