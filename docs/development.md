# bbb-docker Development

## Basics
normally people start BBB with the pre-built docker images, but for developing you need to build them by yourself. For that you need to ensure that the submodules are also checked out:

```sh
$ git submodule update --init
```


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
TURN_SERVER=turns:localhost:5349?transport=tcp

TURN_SECRET=SuperTurnSecret
SHARED_SECRET=SuperSecret
ETHERPAD_API_KEY=SuperEtherpadKey
RAILS_SECRET=SuperRailsSecret_SuperRailsSecret

# ====================================
# CUSTOMIZATION
# ====================================

[... add rest of sample.env here ...]
```

- regenerate `docker-compose.yml` \
  `$ ./scripts/generate-compose`
- build the images \
  `$ docker compose build`
- you can than start it with \
  `$ docker compose up -d`
- view the logs with \
  `$ docker compose logs -f`
- and access the API via \
  https://mconf.github.io/api-mate/#server=https://10.7.7.1/bigbluebutton/api&sharedSecret=SuperSecret
    * At some point your browser will warn you about an invalid certificate, but you can press _"Accept the Risk and Continue" / "Proceed to 10.7.7.1 (unsafe)"_


## Notes
- Due to the self signed ssl certificate it is currently not possible to notify greenlight about recordings in dev mode

## Changes
- After doing some changes you usually must...
  - recreate `docker-compose.yml` \
    `$ ./scripts/generate-compose`
  * rebuild the image(s): \
    `$ docker compose build [containername]`
  * restart changes image(s): \
    `$ docker compose up -d`


## How to do create a new update for a newer BBB release?
This always consists out of following steps
1. **Get an understanding about changes that happened and find out what changes to bbb-docker that require.** \
    * main source for that are the release notes in https://github.com/bigbluebutton/bigbluebutton/releases
2. **Apply these changes to this project.** 
    * Often you only need to checkout the git submodules to the specific release tag
      * List of all submodules: `git submodule`   
3. Test everything (with firefox **and** chromium/chrome)
    * Audio
    * Video
    * Presentation upload
    * Shared Notes
4. Create a `CHANGELOG.md` entry
5. Create a Pull Request
6. Receive big thanks from @alangecker 
