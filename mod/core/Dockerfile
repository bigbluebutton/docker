FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

# TODO:
# - separate bbb-apps into an own container
# - separate bbb-web
# - remove systemd

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && apt-get install -y software-properties-common language-pack-en wget
RUN update-locale LANG=en_US.UTF-8
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:rmescandon/yq
RUN apt-get install -y --no-install-recommends apt-utils

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install dev helpers
# RUN apt-get install -y  tcpdump telnet htop vim

# -- Install Dependencies
RUN apt-get install -y systemd apt-transport-https equivs libreoffice haveged ttf-liberation net-tools

# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://packages-eu.bigbluebutton.org/xenial-22 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list'

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && dpkg -i /*.deb \
    && rm /*.deb

# -- create dummy service to avoid start up errors
COPY dummy.service /etc/systemd/system/redis-server.service

RUN apt-get update && apt-get install -y bbb-web \
                    bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka bbb-apps \
                    bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast

# -- avoid blocking java 
# https://github.com/bigbluebutton/bigbluebutton/issues/8959
RUN sed -i 's|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g'  /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

# -- Disable unneeded services
RUN find /etc/systemd/ | grep wants | xargs -r -n 1 basename | grep service | grep -v networking | grep -v tty   | xargs -r -n 1 -I __ systemctl disable __
RUN systemctl disable systemd-journal-flush systemd-update-utmp.service
RUN systemctl enable red5 bbb-apps-akka bbb-transcode-akka bbb-fsesl-akka bbb-web # bbb-rap-caption-inbox

# -- fix directory permissions
RUN chown bigbluebutton:bigbluebutton /var/bigbluebutton

COPY entrypoint.sh /entrypoint.sh

# -- copy configuration files
COPY red5.properties /usr/share/red5/conf/red5.properties
COPY bigbluebutton.properties /usr/share/red5/webapps/bigbluebutton/WEB-INF/bigbluebutton.properties
COPY bigbluebutton-sip.properties /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
COPY bigbluebutton.yml /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml

COPY web/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl
COPY bbb-apps-akka/application.conf /usr/share/bbb-apps-akka/conf/application.conf.tmpl
COPY bbb-fsesl-akka/application.conf /etc/bbb-fsesl-akka/application.conf
COPY web-run.sh /usr/share/bbb-web/run-prod.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []

