#!/bin/sh -e
cd /app
sed -i "s|^\(localIpAddress\):.*|\1: \"10.7.7.10\"|g" config/production.yml
export KURENTO_IP="10.7.7.1"

exec "$@"
