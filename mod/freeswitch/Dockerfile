FROM debian:buster-slim

ARG BBB_REPO_URL
ENV BBB_REPO_URL $BBB_REPO_URL
ARG BBB_BRANCH_OR_TAG
ENV BBB_BRANCH_OR_TAG $BBB_BRANCH_OR_TAG

# upgrade git so we have the sparse checkout and clone with filter feature
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git \
    && apt-get clean all

# add freeswitch repo
RUN apt-get update && \
apt-get install -y --no-install-recommends curl wget ca-certificates gnupg gnupg2 lsb-release unzip && \
curl -k https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
echo 'deb http://files.freeswitch.org/repo/deb/debian-release/ buster main' > /etc/apt/sources.list.d/freeswitch.list

# install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install freeswitch
RUN apt-get update && apt-get install -y \
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
        freeswitch-mod-sofia \
        freeswitch-sounds-en-us-callie \
        iptables

# get official bbb freeswitch config
# clone only bbb-voice-conference/config/freeswitch/conf subfolder
RUN git clone --filter=blob:none --no-checkout $BBB_REPO_URL \
    && cd bigbluebutton \
    && git sparse-checkout set bbb-voice-conference/config/freeswitch/conf \
    && git checkout $BBB_BRANCH_OR_TAG -b docker-build

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

RUN ls bigbluebutton/bbb-voice-conference/config/freeswitch/conf/
RUN cp -R bigbluebutton/bbb-voice-conference/config/freeswitch/conf/* /etc/freeswitch

RUN ls /etc/freeswitch

# add modifications
COPY ./conf /etc/freeswitch/
RUN ls /etc/freeswitch

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh