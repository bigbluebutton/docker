# bbb-docker Development

## Basics
normally people start BBB with the pre-built docker images, but for developing you need to build them by yourself. For that you need to ensure that the submodules are also checked out

```sh
$ git clone --recurse-submodules https://github.com/bigbluebutton/docker.git bbb-dev
$ cd bbb-dev
```

## Running
you can now run bbb-docker locally by simply starting

```sh
$ ./scripts/dev
```

### Hints
- the html5 component will watch and automatically reload on any changes 🚀
- if you change anything in the other components, you need to
  * manually rebuilt it \
    `$ docker compose build CONTAINERNAME`
  * restart it \
    `$ docker compose up -d CONTAINERNAME`
- if you change any variable in .env, always run following to rebuild the `docker-compose.yml``
  `$ ./scripts/generate-compose`
- view the logs with \
  `$ docker compose logs -f`
- and access the API via \
  https://mconf.github.io/api-mate/#server=https://10.7.7.1/bigbluebutton/api&sharedSecret=SuperSecret
    * At some point your browser will warn you about an invalid certificate, but you can press _"Accept the Risk and Continue" / "Proceed to 10.7.7.1 (unsafe)"_


## Notes
- Due to the self signed ssl certificate it is currently not possible to notify greenlight about recordings in dev mode

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
