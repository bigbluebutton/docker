#!/bin/sh -e

# use /tmp as home dir as writeable directory for whatever UID we get
export HOME=/tmp


export MONGO_OPLOG_URL=mongodb://10.7.7.6/local
export MONGO_URL=mongodb://10.7.7.6/meteor
export ROOT_URL=http://127.0.0.1/html5client
export BIND_IP=0.0.0.0
export LANG=en_US.UTF-8
export BBB_HTML5_LOCAL_SETTINGS=/tmp/bbb-html5.yml

echo "DEV_MODE=true, disable TLS certificate rejecting"
export NODE_TLS_REJECT_UNAUTHORIZED=0


if [ ! -f "/tmp/.meteor/copy-done" ]; then
    echo "# copying over .meteor from docker image... (this might take some minutes)"
    cp -a /root/.meteor/* /tmp/.meteor
    touch /tmp/.meteor/copy-done
fi

cd /app
echo "# meteor npm install"
meteor npm install

echo "# npm start"
dockerize \
    -template /tmp/bbb-html5.yml.tmpl:/tmp/bbb-html5.yml \
    npm start
