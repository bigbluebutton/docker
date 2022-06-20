FROM debian:bullseye-slim

# install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    subversion curl wget ca-certificates gnupg gnupg2 lsb-release unzip

COPY --from=alangecker/bbb-docker-base-java /usr/local/bin/dockerize /usr/local/bin/dockerize


# install freeswitch
RUN wget -q -O /usr/share/keyrings/freeswitch-archive-keyring.gpg https://freeswitch-mirror.chandi.it/repo/deb/debian-release/signalwire-freeswitch-repo.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] http://freeswitch-mirror.chandi.it/repo/deb/debian-release/ bullseye main' > /etc/apt/sources.list.d/freeswitch.list && \
    apt-get update && \
    apt-get install -y \
        freeswitch \
        freeswitch-mod-commands \
        freeswitch-mod-conference \
        freeswitch-mod-console \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-dptools \
        freeswitch-mod-event-socket \
        freeswitch-mod-native-file \
        freeswitch-mod-opusfile \
        freeswitch-mod-opus \
        freeswitch-mod-sndfile \
        freeswitch-mod-spandsp \
        freeswitch-mod-sofia \
        freeswitch-sounds-en-us-callie \
        iptables

# replace mute & unmute sounds
RUN wget -q https://gitlab.senfcall.de/senfcall-public/mute-and-unmute-sounds/-/archive/master/mute-and-unmute-sounds-master.zip && \
    unzip mute-and-unmute-sounds-master.zip && \
    cd mute-and-unmute-sounds-master/sounds/ && \
    find . -name "*.wav" -exec /bin/bash -c "echo {};sox -v 0.3 {} /tmp/tmp.wav; mv /tmp/tmp.wav /usr/share/freeswitch/sounds/en/us/callie/conference/{}" \; && \
    cd ../.. && \
    rm -r mute-and-unmute-sounds-master mute-and-unmute-sounds-master.zip


# -- get official bbb freeswitch config
# we use svn for retrieving the files since the repo is quite large,
# git sparse-checkout is not yet available with buster and there
# is no other sane way of downloading a single directory via git

ARG TAG_FS_CONFIG
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_FS_CONFIG/bbb-voice-conference/config/freeswitch/conf /etc/freeswitch \
    && rm -rf /etc/freeswitch/.svn

# the current available freeswitch-mod-opusfile is broken,
# it can't write any .opus files. The fix provided in
# https://github.com/signalwire/freeswitch/pull/719/files
# is not sufficient as the module still comes without opus
# write support, so we rather switch to the binary built
# by bigbluebutton and add its dependencies
RUN wget -O /usr/lib/freeswitch/mod/mod_opusfile.so https://github.com/bbb-pkg/bbb-freeswitch-core/raw/43f3a47af1fcf5ea559e16bb28b900c925a7f2c3/opt/freeswitch/lib/freeswitch/mod/mod_opusfile.so \
    && wget -O /tmp/libopusenc0_0.2.1-1bbb1_amd64.deb https://launchpad.net/~bigbluebutton/+archive/ubuntu/support/+files/libopusenc0_0.2.1-1bbb1_amd64.deb \
    && dpkg -i /tmp/libopusenc0_0.2.1-1bbb1_amd64.deb \
    && rm /tmp/libopusenc0_0.2.1-1bbb1_amd64.deb

# add modifications
COPY ./conf /etc/freeswitch/


COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh