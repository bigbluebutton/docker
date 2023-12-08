# Changelog

## Unreleased

## Release v2.7.3 (2023-12-08)

**Breaking change!** make sure to read the [upgrading notes](https://github.com/bigbluebutton/docker/blob/develop/docs/upgrading.md)

- BigBlueButton 2.7.3 @alangecker [#304](https://github.com/bigbluebutton/docker/pull/304)
- use local sources instead of pulling inside container @alangecker [#307](https://github.com/bigbluebutton/docker/pull/307)
- BigBlueButton 2.7.0 @alangecker [#291](https://github.com/bigbluebutton/docker/pull/291)
- Update to ComposeV2 @leonidas-o [#271](https://github.com/bigbluebutton/docker/pull/271)
- recordings: fix for missing `SHARED_SECRET` @ichdasich [#274](https://github.com/bigbluebutton/docker/issues/274) [#268](https://github.com/bigbluebutton/docker/issues/268)
- Add RESOLVER_ADDRESS to env for docker-nginx-auto-ssl @pkolmann [#277](https://github.com/bigbluebutton/docker/pull/277)
- Fix learning-dashboard @yanus [#262](https://github.com/bigbluebutton/docker/pull/262)

## Release v2.6.0-2 (2023-04-04)
- hotfix for broken freeswitch container due to enabled compresion with max file count == 1 [#260](https://github.com/bigbluebutton/docker/issues/260)

## Release v2.6.0 (2023-04-03)
- **Breaking change:** Greenlight v3 (see [upgrade note](docs/upgrading.md) @alangecker [#255](https://github.com/bigbluebutton/docker/pull/255) 
- BigBlueButton v2.6 @alangecker [#255](https://github.com/bigbluebutton/docker/pull/255) 
- Set client_max_body_size for greenlight @nr23730 [#252](https://github.com/bigbluebutton/docker/pull/252)
- self building freeswitch (applying patches and independent from external apt repos) @alangecker
- reduce amount of logs with senstivie data @alangecker

## Release v2.5.8 (2022-11-06)
- BBB 2.5.8 @alangecker [#238](https://github.com/bigbluebutton/docker/pull/238)
- recordings: fix for missing ffmpeg filter @alangecker [#235](https://github.com/bigbluebutton/docker/issues/235) [#230](https://github.com/bigbluebutton/docker/pull/230)

## Release v2.5.0 (2022-06-10)
- BigBlueButton v2.5 @alangecker [#207](https://github.com/bigbluebutton/docker/pull/207)
- central `tags.env` file with the tag names of most BBB components @alangecker
- Usage of [official docker build images](https://gitlab.senfcall.de/senfcall-public/docker-bbb-build) for building @alangecker
- publish docker images @alangecker [#174](https://github.com/bigbluebutton/docker/issues/174)
- etherpad: enforce bbb-pads session handling @pedrobmarin [#211](https://github.com/bigbluebutton/docker/pull/211)
- etherpad: avoid icons overlapping @pedrobmarin [#210](https://github.com/bigbluebutton/docker/pull/210)
- fix recordings which include presentation polls @lightweight [#205](https://github.com/bigbluebutton/docker/pull/205)

## Release v2.4.5 (2022-03-24)
- Applied BBB v2.4.5 changes @alangecker 
- New mute & unmute sounds by senfcall
- Update etherpad @pedrobmarin [#202](https://github.com/bigbluebutton/docker/pull/202)
- Use own freeswitch mirror instead of the official login-only one @alangecker [#203](https://github.com/bigbluebutton/docker/issues/203)
- Ignore docker-compose.override.yml @dorianim [#183](https://github.com/bigbluebutton/docker/pull/183)

## Release v2.4.4 (2022-02-23)
- Applied v2.4.4 changes @alangecker [#195](https://github.com/bigbluebutton/docker/pull/195)
- Update Russian sound announcement examples @lexuzieel [#196](https://github.com/bigbluebutton/docker/pull/196)
- fix for presentation slides not displayed if they contain type 3 fonts @rottaran  [#191](https://github.com/bigbluebutton/docker/pull/191)

## Release v2.4.0 (2021-12-29)
- BigBlueButton v2.4 @alangecker [#159](https://github.com/bigbluebutton/docker/pull/159)
- **Breaking change:** change nginx port from `8080` to `48087`. see [upgrade note](docs/upgrading.md) @alangeker [#133](https://github.com/bigbluebutton/docker/issues/133)
- Enable optimization for Prometheus Exporter when recording is enabled @omidmaldar [#161](https://github.com/bigbluebutton/docker/pull/161)
- Automatically remove old recordings after N days @omidmaldar [#162](https://github.com/bigbluebutton/docker/pull/162)


## Release v2.3.14-1 (2021-10-06)
- Applied changes v2.3.5-v2.3.14 @alangecker
- updated wget to not use proxies [#143](https://github.com/bigbluebutton/docker/pull/143) @mghadam
- fixed sed delimiter for CERTPATH and KEYPATH [#144](https://github.com/bigbluebutton/docker/pull/144) @mghadam
- https_proxy: fix setting of ALLOWED_DOMAINS [#145](https://github.com/bigbluebutton/docker/pull/145) @clandmeter
- coturn: expose ENABLE_HTTPS_PROXY env variable [#146](https://github.com/bigbluebutton/docker/pull/146) [#156](https://github.com/bigbluebutton/docker/pull/156) @clandmeter @omidmaldar

## Release v2.3.4-1 (2021-06-22) #131
- Applied v2.3.4 changes [#130](https://github.com/bigbluebutton/docker/pull/130) @alangecker 
- Reintegrate turn with default ports and support for external certificates [#126](https://github.com/bigbluebutton/docker/pull/126) @cjhille
- Fix freeswitch package names for languages with uppercase characters in the path  [#119](https://github.com/bigbluebutton/docker/pull/119) @lexuzieel
- Exclude CLIENT_TITLE when generating compose file [#118](https://github.com/bigbluebutton/docker/pull/118) @bb
- Fix for preuploaded presentations not working [#116](https://github.com/bigbluebutton/docker/pull/116) @manfred-w
- Add POSTGRESQL_SECRET as environement variable [#111](https://github.com/bigbluebutton/docker/pull/111) @caminsha


## Release v2.3.0
- :tada: **BigBlueButton 2.3** including all its changes
- Template based generation of docker-compose.yml [2.2.x#71](https://github.com/alangecker/bigbluebutton-docker/pull/71) [2.2.x#42](https://github.com/alangecker/bigbluebutton-docker/issues/42) @trickert76 @alangecker
- Removal of `core` and all dependencies on the bigbluebutton ubuntu repository. Seperate container for `bbb-web`, `fsesl-akka` and `apps-akka` [2.2.x#26](https://github.com/alangecker/bigbluebutton-docker/issues/26) @alangecker
- Fix recordings for Moodle BBB plugin: [2.2.x#110](https://github.com/alangecker/bigbluebutton-docker/pull/110) @danjesus
- Fixed recordings container restart setting [2.2.x#109](https://github.com/alangecker/bigbluebutton-docker/pull/109) @manfred-w
- Option for freeswitch language [2.2.x#85](https://github.com/alangecker/bigbluebutton-docker/pull/85) @alangecker @Daedalus3 
- Disabled integrated coturn [#73](https://github.com/bigbluebutton/docker/issues/73)

## Release v2.2.31-1 (2020-12-23) #84
- Applied v2.2.31 changes @alangecker
- Fix when presentation after recording unable to delete and change access rights #82 #63 @cardinalit
- Enable cameraQualityThresholds by default

## Release v2.2.30-1 (2020-12-01) #79
- Applied v2.2.30 changes @alangecker
- Applied v2.2.29 changes @alangecker
- Fix bug due to unnecessary port forward #81 @trickert76 @alangecker

## Release v2.2.28-1 (2020-10-22) #67
- Applied v2.2.28 changes @alangecker
- Etherpad skin & plugin #69 @alangecker
- Updated `development.md` docs (example config & note about issue #66) @alangecker
- Allow setting the breakout room limit @alangecker

## Release v2.2.27-2 (2020-10-16)
- Increase proxy timeout to avoid aborting websocket connections @alangecker
- Added a changelog

## Release v2.2.27-1 (2020-10-14)
- Applied BBB v2.2.27 changes https://github.com/bigbluebutton/bigbluebutton/releases/tag/v2.2.27 @alangecker
- Upgrade docker base images (etherpad and bigbluebutton-exporter) @alangecker

## Release v2.2.26-1 (2020-09-29)
- Applied changes from BBB v2.2.24 to v2.2.26 #58 #60 @alangecker

## Release v2.2.23-1 (2020-09-06)
- :tada: Recording #16 by @artemtech and @alangecker 
- v2.2.23 changes by @alangecker 
- sip_profile extension field #54 by @yksflip
- Remove greenlight container name #49 by @alangecker 

## Hotfix (2020-08-15)
- Allow imagemagick to convert to pdf/svg #51 #52 @alangecker

## Release v2.2.22-1 (2020-08-12) #50
- v2.2.22 changes by @alangecker 
- Disable freeswitch logfiles inside containers

## Release v2.2.21-1 (2020-7-18)
- Changes for v2.2.21 #44 @alangecker
- expose more BBB settings in .env file #34 @cjhille
- IPv6 Support #32 @alangecker
- Development Mode & Instructions #39 @alangecker
- Prometheus Exporter Integration #40 @alangecker
