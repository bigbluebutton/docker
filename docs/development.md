# bbb-docker Development

## Running
you can run bbb-docker locally without any certificate issues with following `.env` configurations:

```
DEV_MODE=true

ENABLE_HTTPS_PROXY=true
#ENABLE_COTURN=true
#ENABLE_GREENLIGHT=true
#ENABLE_WEBHOOKS=true
#ENABLE_PROMETHEUS_EXPORTER=true
#ENABLE_RECORDING=true

DOMAIN=10.7.7.1
EXTERNAL_IPv4=10.7.7.1
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

- regenerate `docker-compose.yml` \
  `$ ./scripts/generate-compose`
- you can than start it with \
  `$ docker-compose up -d`
- view the logs with \
  `$ docker-compose logs -f`
- and access the API via \
  https://mconf.github.io/api-mate/#server=https://10.7.7.1/bigbluebutton/api&sharedSecret=SuperSecret
    * At some point your browser will warn you about an invalid certificate, but you can press _"Accept the Risk and Continue" / "Proceed to 10.7.7.1 (unsafe)"_


## Notes
- Joining a room via Greenlight currently leads to a "401 session not found" error (see https://github.com/alangecker/bigbluebutton-docker/issues/66). Use the API Mate instead

## Changes
- After doing some changes you usually must...
  - recreate `docker-compose.yml` \
    `$ ./scripts/generate-compose`
  * rebuild the image(s): \
    `$ docker-compose build [containername]`
  * restart changes image(s): \
    `$ docker-compose up -d`


## How to do create a new update for a newer BBB release?
This always consists out of following steps
1. **Get an understanding about changes that happened and find out what changes to bbb-docker that require.** \
    * Sometimes there are changes made which are not accessible in the [bigbluebutton/bigbluebutton](https://github.com/bigbluebutton/bigbluebutton) repo, so you should rather look through all the related commits in [alangecker/bbb-packages](https://github.com/alangecker/bbb-packages/commits/master)
    * Before being overwhelmed: All these compiled `.js`,`.class`,etc. files are irrelevant to check! :)
2. **Apply these changes to this project.** 
    * Quite often you only need to set `TAG` to the corresponding release tag in [bigbluebutton/bigbluebutton](https://github.com/bigbluebutton/bigbluebutton) like `v2.2.31`. To avoid the unnecessary recreation of images, only change the TAG of those components, which actually received a change.
    * New config variables are also quite common
    * don't forget to checkout a newer version of `bbb-webrtc-sfu` if it also happened in the release. you can find out what the current version is [here](https://github.com/alangecker/bbb-packages/blob/v2.3.x/bbb-webrtc-sfu/data/usr/local/bigbluebutton/bbb-webrtc-sfu/package.json)
    * if available, you can also think about switching to more recent images of kurento, etherpad, nginx, etc.
3. Test everything (with firefox **and** chromium/chrome)
    * Audio
    * Video
    * Presentation upload
    * Shared Notes
4. Create a `CHANGELOG.md` entry
5. Create a Pull Request
6. Receive big thanks from @alangecker 
