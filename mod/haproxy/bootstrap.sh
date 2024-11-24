#!/usr/bin/env bash

set -e

# save container environment variables to use it
# in cron scripts

declare -p | grep -Ev '^declare -[[:alpha:]]*r' > /container.env


if [ "x$CERT1" = "x10.7.7.1" ]; then
    # use self signed certificate
    if [ ! -f /etc/haproxy/certs/haproxy-10.7.7.1.pem ]; then
        mkdir -p /etc/haproxy/certs
        # generate self signed certificate
        openssl req -x509 -nodes -days 700 -newkey rsa:2048 \
        -keyout /tmp/domain.key -out /tmp/domain.crt \
        -subj "/C=CA/ST=Quebec/L=Montreal/O=BigBlueButton Development/OU=bbb-docker/CN=10.7.7.1"

        cat /tmp/domain.key /tmp/domain.crt | tee /etc/haproxy/certs/haproxy-10.7.7.1.pem >/dev/null
    fi
else
    # obtain certificates from lets encrypt
    /certs.sh
fi
supervisord -c /etc/supervisord.conf -n