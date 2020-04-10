FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

# TODO:
# - separate bbb-apps into an own container
# - separate bbb-web
# - remove systemd
# - checkfor removeable dependencies and dummy services

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV DOCKERIZE_VERSION v0.6.1

# just to speed up development, TODO: remove
COPY sources.list /etc/apt/sources.list 


RUN apt-get update && apt-get install -y software-properties-common language-pack-en wget
RUN update-locale LANG=en_US.UTF-8
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:rmescandon/yq
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get update

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install dev helpers
RUN apt-get install -y  tcpdump telnet htop vim

# -- Install Dependencies
RUN apt-get install -y systemd apt-transport-https equivs libreoffice 

# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/xenial-220 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list'  \
    && apt-get update

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && equivs-control nginx.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/nginx/g' nginx.control \
    && equivs-build nginx.control \
    && equivs-control bbb-webrtc-sfu.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/bbb-webrtc-sfu/g' bbb-webrtc-sfu.control \
    && equivs-build bbb-webrtc-sfu.control \
    && dpkg -i /*.deb \
    && rm /*.deb

# -- create nginx service (in order to enable it - to avoid the "nginx.service is not active" error)
RUN rm -f /etc/systemd/system/nginx.service
COPY dummy.service /etc/systemd/system/nginx.service
COPY dummy.service /etc/systemd/system/redis.service
COPY dummy.service /etc/systemd/system/redis-server.service
COPY dummy.service /etc/systemd/system/bbb-webrtc-sfu.service

RUN touch /etc/init.d/nginx && chmod +x /etc/init.d/nginx
RUN apt-get update && apt-get install -y bbb-web bbb-freeswitch-core \
                    bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka bbb-apps bbb-apps-sip \
                    bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast

# disable IPv6 support
RUN rm -rf /opt/freeswitch/conf/sip_profiles/*-ipv6*

# -- Disable unneeded services
RUN find /etc/systemd/ | grep wants | xargs -r -n 1 basename | grep service | grep -v networking | grep -v tty   | xargs -r -n 1 -I __ systemctl disable __
RUN systemctl disable systemd-journal-flush
RUN systemctl disable systemd-update-utmp.service
RUN systemctl enable red5 freeswitch bbb-apps-akka bbb-transcode-akka bbb-fsesl-akka bbb-web # bbb-rap-caption-inbox

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []

