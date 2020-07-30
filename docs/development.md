# bbb-docker Development

## Running
you can run bbb-docker locally without any certificate issues with following `.env` configurations:

```
DEV_MODE=true

ENABLE_HTTPS_PROXY=true
#ENABLE_COTURN=true
#ENABLE_GREENLIGHT=true
#ENABLE_WEBHOOKS=true

DOMAIN=10.7.7.1
EXTERNAL_IP=10.7.7.1
STUN_IP=216.93.246.18
STUN_PORT=3478
TURN_SERVER=turns:localhost:465?transport=tcp

TURN_SECRET=SuperTurnSecret
SHARED_SECRET=SuperSecret
ETHERPAD_API_KEY=SuperEtherpadKey
RAILS_SECRET=SuperRailsSecret

# ====================================
# CUSTOMIZATION
# ====================================

[... add rest of sample.env here ...]
```

- you can than start it with \
  `$ ./scripts/compose up -d`
- view the logs with \
  `$ ./scripts/compose logs -f`
- and access the API via \
  https://mconf.github.io/api-mate/#server=https://10.7.7.1/bigbluebutton/api&sharedSecret=SuperSecret
    * At some point your browser will warn you about an invalid certificate, but you can press _"Accept the Risk and Continue" / "Proceed to 10.7.7.1 (unsafe)"_

## Changes
- After doing some changes you usually must...
  * rebuild the image(s): \
    `$ ./scripts/compose build [containername]`
  * restart changes image(s): \
    `$ ./scripts/compose up -d`