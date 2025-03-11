#!/bin/bash

# get owner of /app
OWNER="$(stat -c '%u' "/app")"
GROUP="$(stat -c '%g' "/app")"
useradd --home-dir /tmp -u $OWNER user || /bin/true

# run with same user to avoid any issues
# with file permissions
. /root/.nvm/nvm.sh
gosu $OWNER:$GROUP bash -c "$@"

