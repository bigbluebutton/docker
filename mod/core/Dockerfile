FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

# TODO:
# - separate bbb-apps into an own container
# - separate bbb-web

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && apt-get install -y software-properties-common language-pack-en wget apt-utils
RUN update-locale LANG=en_US.UTF-8
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:rmescandon/yq

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install dev helpers
# RUN apt-get install -y  tcpdump telnet htop vim

# -- Install Dependencies
RUN apt-get install -y supervisor apt-transport-https equivs libreoffice haveged ttf-liberation net-tools

# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/xenial-22 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list'

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && dpkg -i /*.deb \
    && rm /*.deb

# this variable is not used, but it triggers
# rebuilding from here on if changed
ENV VERSION v2.2.26

RUN apt-get update && apt-get install -y bbb-web \
                    bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka bbb-apps \
                    bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast

# -- avoid blocking java
# https://github.com/bigbluebutton/bigbluebutton/issues/8959
RUN sed -i 's|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g'  /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

# add blank presentation files and allow conversation to pdf/svg
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && wget -O /usr/share/bigbluebutton/blank/blank-svg.svg https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-svg.svg \
    && wget -O /usr/share/bigbluebutton/blank/blank-thumb.png https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-thumb.png \
    && wget -O /usr/share/bigbluebutton/blank/blank-presentation.pdf https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-presentation.pdf \
    && wget -O /usr/share/bigbluebutton/blank/blank-png.png https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-png.png \
    && sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml


# -- copy configuration files
COPY red5-webapps/bigbluebutton/application.conf /usr/share/red5/webapps/bigbluebutton/WEB-INF/classes/application.conf
COPY red5-webapps/bigbluebutton/bigbluebutton.properties /usr/share/red5/webapps/bigbluebutton/WEB-INF/bigbluebutton.properties
COPY red5-webapps/bigbluebutton/redis.properties /usr/share/red5/webapps/bigbluebutton/WEB-INF/redis.properties
COPY red5-webapps/sip/bigbluebutton-sip.properties /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
COPY red5-webapps/screenshare/screenshare.properties /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties
COPY red5-webapps/screenshare/screenshare-app.conf /usr/share/red5/webapps/screenshare/WEB-INF/classes/screenshare-app.conf
COPY red5-webapps/screenshare/application.conf /usr/share/red5/webapps/screenshare/WEB-INF/classes/application.conf
COPY red5-webapps/video/bigbluebutton-video.properties /usr/share/red5/webapps/video/WEB-INF/bigbluebutton-video.properties
COPY red5-webapps/video-broadcast/video-broadcast.properties /usr/share/red5/webapps/video-broadcast/WEB-INF/video-broadcast.properties

COPY web/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl
COPY web/turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl

COPY bbb-apps-akka/application.conf /usr/share/bbb-apps-akka/conf/application.conf.tmpl
COPY bbb-fsesl-akka/application.conf /etc/bbb-fsesl-akka/application.conf
COPY bbb-transcode-akka/application.conf /etc/bbb-transcode-akka/application.conf
COPY web-run.sh /usr/share/bbb-web/run-prod.sh

# add default presentation thumbnail
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && wget -O /usr/share/bigbluebutton/blank/blank-thumb.png https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.2.20/bigbluebutton-config/slides/blank-thumb.png

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

COPY prefix-log /usr/local/bin/prefix-log
RUN mkdir -p /var/log/supervisor

ENTRYPOINT ["/entrypoint.sh"]
CMD []
