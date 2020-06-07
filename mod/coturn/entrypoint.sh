#!/bin/sh
set -e 
apk add jq

while [ ! -f /etc/resty-auto-ssl/storage/file/*latest ]
do
  echo "ERROR: certificate doesn't exist yet."
  echo "Certificate gets create on the first request to the HTTPS proxy."
  echo "We will try again..."
  sleep 10
done

# extract cert
cat /etc/resty-auto-ssl/storage/file/*%3Alatest | jq -r '.fullchain_pem' > /tmp/cert.pem
cat /etc/resty-auto-ssl/storage/file/*%3Alatest | jq -r '.privkey_pem' > /tmp/key.pem


# If command starts with an option, prepend with turnserver binary.
if [ "${1:0:1}" == '-' ]; then
  set -- turnserver "$@"
fi

exec $(eval "echo $@")