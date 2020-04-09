#!/bin/bash -e
#Allow to run outside of directory
cd `dirname $0`

if [ -w /sys/kernel/mm/transparent_hugepage/enabled ]; then
  unameEnabled="$(stat --format '%U' /sys/kernel/mm/transparent_hugepage/enabled)"
  if [ "x${unameEnabled}" != "xnobody" ]; then
      echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
      echo "transparent_hugepage/enabled set to 'never'"
  else
      echo "transparent_hugepage/enabled could not be set to 'never'"
  fi
fi

if [ -w /sys/kernel/mm/transparent_hugepage/defrag ]; then
  unameDefrag="$(stat --format '%U' /sys/kernel/mm/transparent_hugepage/defrag)"
  if [ "x${unameDefrag}" != "xnobody" ]; then
      echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
      echo "transparent_hugepage/defrag set to 'never'"
  else
      echo "transparent_hugepage/defrag could not be set to 'never'"
  fi
fi

# change to start meteor in production (https) or development (http) mode
ENVIRONMENT_TYPE=production

cd /usr/share/meteor/bundle
export ROOT_URL=http://127.0.0.1/html5client
export MONGO_URL=mongodb://10.7.7.6/meteor
export NODE_ENV=production
PORT=3000 /usr/bin/node main.js
