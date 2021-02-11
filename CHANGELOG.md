# Changelog

## Unreleased
- **BigBlueButton 2.3** including all its changes :tada:
- Template based generated of docker-compose.yml #71 #42 @alangecker @trickert76
- Removal of `core` and all dependencies on the bigbluebutton ubuntu repository. Seperate container for `bbb-web`, `fsesl-akka` and `apps-akka` #26 @alangecker

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
