FROM debian:buster-slim

# add freeswitch repo
RUN apt-get update && \
apt-get install -y --no-install-recommends curl wget ca-certificates gnupg gnupg2 lsb-release && \
curl -k https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
echo 'deb http://files.freeswitch.org/repo/deb/debian-release/ buster main' > /etc/apt/sources.list.d/freeswitch.list && \
apt-get update

# install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install freeswitch
RUN apt-get install -y \
        freeswitch \
        freeswitch-mod-amr \
        freeswitch-mod-b64 \
        freeswitch-mod-commands \
        freeswitch-mod-conference \
        freeswitch-mod-console \
        freeswitch-mod-db \
        freeswitch-mod-dialplan-asterisk \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-dptools \
        freeswitch-mod-enum \
        freeswitch-mod-esf \
        freeswitch-mod-event-socket \
        freeswitch-mod-expr \
        freeswitch-mod-fifo \
        freeswitch-mod-fsv \
        freeswitch-mod-g723-1 \
        freeswitch-mod-g729 \
        freeswitch-mod-hash \
        freeswitch-mod-httapi \
        freeswitch-mod-local-stream \
        freeswitch-mod-logfile \
        freeswitch-mod-loopback \
        freeswitch-mod-lua \
        freeswitch-mod-native-file \
        freeswitch-mod-opusfile \
        freeswitch-mod-opus \
        freeswitch-mod-png \
        freeswitch-mod-rtc \
        freeswitch-mod-say-en \
        freeswitch-mod-sndfile \
        freeswitch-mod-sofia \
        freeswitch-mod-spandsp \
        freeswitch-mod-tone-stream \
        freeswitch-mod-verto \
        freeswitch-sounds-en-us-callie

# Potentially missing
# (included in bbb-freeswitch-core but not referenced in https://github.com/bigbluebutton/bigbluebutton/issues/9064)
# freeswitch-mod-cdr-csv
# freeswitch-mod-cdr-sqlite
# freeswitch-mod-h26x
# freeswitch-mod-skinny
# freeswitch-mod-sms
# freeswitch-mod-syslog
# freeswitch-mod-valet-parking
# freeswitch-mod-voicemail
# freeswitch-mod-xml-cdr
# freeswitch-mod-xml-rpc
# freeswitch-mod-xml-scgi

COPY ./conf /etc/freeswitch
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh