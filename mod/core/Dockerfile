FROM ubuntu:18.04
MAINTAINER ffdixon@bigbluebutton.org

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && apt-get install -y software-properties-common language-pack-en wget apt-utils
RUN update-locale LANG=en_US.UTF-8

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install dev helpers
# RUN apt-get install -y  tcpdump telnet htop vim

# -- Install Dependencies
RUN apt-get install -y supervisor apt-transport-https equivs haveged fonts-crosextra-carlito fonts-crosextra-caladea fonts-noto net-tools socat

# add bigbluebutton user manually so the ID is constant
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://packages-eu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/bionic-230-dev bigbluebutton-bionic main" > /etc/apt/sources.list.d/bigbluebutton.list'

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && dpkg -i /*.deb \
    && rm /*.deb

RUN equivs-control bbb-libreoffice-docker.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/bbb-libreoffice-docker/g' bbb-libreoffice-docker.control \
    && equivs-build bbb-libreoffice-docker.control \
    && dpkg -i /*.deb \
    && rm /*.deb

RUN echo '#!/bin/bash\necho "mocking: systemctl $@"' > /usr/bin/systemctl && chmod +x /usr/bin/systemctl

# this variable is not used, but it triggers
# rebuilding from here on if changed
ENV VERSION v2.3-alpha-2

RUN apt-get update && apt-get install -y bbb-web openjdk-8-jre-headless

# add blank presentation files and allow conversation to pdf/svg
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && wget -O /usr/share/bigbluebutton/blank/blank-svg.svg https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-svg.svg \
    && wget -O /usr/share/bigbluebutton/blank/blank-thumb.png https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-thumb.png \
    && wget -O /usr/share/bigbluebutton/blank/blank-presentation.pdf https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-presentation.pdf \
    && wget -O /usr/share/bigbluebutton/blank/blank-png.png https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$VERSION/bigbluebutton-config/slides/blank-png.png \
    && sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml


# -- copy configuration files

COPY web/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl
COPY web/turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl

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
