ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=freeswitch / /build/freeswitch

# install most recent git version for proper sparse-checkout support
# https://stackoverflow.com/questions/72223738/failed-to-initialize-sparse-checkout
RUN echo 'deb https://ppa.launchpadcontent.net/git-core/ppa/ubuntu focal main' > /etc/apt/sources.list.d/git-core-ppa.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    apt-get update && \
    apt-get install -y git

# get build files for bbb-freeswitch (build/packages-template/bbb-freeswitch-core/)
COPY --from=build-files / /build/

# mock files expected by build.sh
RUN mkdir -p /build/bbb-voice-conference/config/freeswitch/conf/ && \
    touch \
        /build/opts-build.sh \
        /build/freeswitch.service.build \
        /build/bbb-voice-conference/config/freeswitch/conf/a \
        && \
    echo "" > /usr/local/bin/fpm

# build freeswitch
RUN cd /build && ./build.sh


# add english sounds
RUN mkdir -p /build/staging/opt/freeswitch/share/freeswitch && \
    wget http://bigbluebutton.org/downloads/sounds.tar.gz -O sounds.tar.gz && \
    tar xvfz sounds.tar.gz -C /build/staging/opt/freeswitch/share/freeswitch && \
    wget https://gitlab.senfcall.de/senfcall-public/mute-and-unmute-sounds/-/archive/master/mute-and-unmute-sounds-master.zip && \
    unzip mute-and-unmute-sounds-master.zip && \
    cd mute-and-unmute-sounds-master/sounds && \
    find . -name "*.wav" -exec /bin/bash -c "sox -v 0.3  {} /tmp/tmp.wav; cp /tmp/tmp.wav /build/staging/opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/{}" \;

# add bigblugbutton config
ARG TAG_FS_CONFIG
COPY --from=fs-config / /build/staging/opt/freeswitch/etc/freeswitch/

# ===============================================

# we are using ubuntu here, because libjpeg8 is required, but not available in debian
FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y \
        xmlstarlet wget iptables curl \
        libfreetype6 libcurl4 libspeex1 libspeexdsp1 libopus0 libsndfile1 libopusfile0 liblua5.2-0 libjbig0 libldns2 libedit2 libtiff5 libpng16-16 \
    && \
# install libopusenc0
    wget -O /tmp/libopusenc0_0.2.1-1bbb2_amd64.deb https://launchpad.net/~bigbluebutton/+archive/ubuntu/support/+files/libopusenc0_0.2.1-1bbb2_amd64.deb \
    && dpkg -i /tmp/libopusenc0_0.2.1-1bbb2_amd64.deb \
    && rm /tmp/libopusenc0_0.2.1-1bbb2_amd64.deb

# add dockerize
COPY --from=alangecker/bbb-docker-base-java /usr/local/bin/dockerize /usr/local/bin/dockerize

# copy over built freeswitch & config
COPY --from=builder /build/staging/opt /opt
COPY --from=builder /build/staging/etc /etc

RUN ldconfig && \
    ln -s /opt/freeswitch/conf /etc/freeswitch && \
    groupadd freeswitch && \
    useradd --home-dir /opt/freeswitch --shell /usr/sbin/nologin -g freeswitch freeswitch

COPY ./entrypoint.sh /entrypoint.sh
COPY ./conf /etc/freeswitch/

ENTRYPOINT /entrypoint.sh