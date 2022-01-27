FROM mozilla/sbt:8u212_1.2.8 AS builder

RUN apt-get update && apt-get install -y subversion

# download bbb-common-message
ENV TAG_COMMON_MESSAGE v2.4.1
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_COMMON_MESSAGE/bbb-common-message /bbb-common-message \
    && rm -rf /bbb-common-message/.svn

# compile bbb-common-message
RUN cd /bbb-common-message \
 && ./deploy.sh 

# ===================================================

# install grails
RUN cd /opt \
 && wget -q https://github.com/grails/grails-core/releases/download/v3.3.9/grails-3.3.9.zip \
 && unzip grails-3.3.9.zip
ENV PATH="/opt/grails-3.3.9/bin:${PATH}"

# install gradle
RUN cd /opt \
 && wget -q https://services.gradle.org/distributions/gradle-6.7-bin.zip \
 && unzip gradle-6.7-bin
ENV PATH="/opt/gradle-6.7/bin:${PATH}"

# download bbb-common-web
ENV TAG_COMMON_WEB v2.4.1
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_COMMON_WEB/bbb-common-web /bbb-common-web \
    && rm -rf /bbb-common-message/.svn

# compile bbb-common-web
RUN cd /bbb-common-web \
 && ./deploy.sh

# download bbb-web
ENV TAG_WEB v2.4.1
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_WEB/bigbluebutton-web /bbb-web \
    && rm -rf /bbb-web/.svn

# compile bbb-web
RUN cd /bbb-web && grails assemble

# compile pres-checker
RUN cd /bbb-web/pres-checker && gradle resolveDeps

# extract .war
RUN unzip -q /bbb-web/build/libs/bigbluebutton-0.10.0.war -d /dist


# ===================================================
FROM openjdk:8-jre-slim-bullseye

RUN apt-get update && apt-get install -y \
        wget unzip gosu locales \
        imagemagick xpdf-utils curl

# set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     


# add user & group
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

# add dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget -q https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


# add blank presentation files and allow conversation to pdf/svg
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && cd /usr/share/bigbluebutton/blank \
    && wget \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-svg.svg \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-thumb.png \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-presentation.pdf \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-png.png \
    && sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml

# get bbb-web
COPY --from=builder /dist /usr/share/bbb-web

# get pres-checker
COPY --from=builder /bbb-web/pres-checker/lib /usr/share/prescheck/lib
COPY --from=builder /bbb-web/pres-checker/run.sh /usr/share/prescheck/prescheck.sh

COPY mocked-ps /usr/bin/ps

# add entrypoint and templates
COPY entrypoint.sh /entrypoint.sh
COPY bbb-web.properties /etc/bigbluebutton/bbb-web.properties.tmpl
COPY turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl
COPY logback.xml /usr/share/bbb-web/WEB-INF/classes/logback.xml
COPY office-convert.sh /usr/share/bbb-libreoffice-conversion/convert.sh

ENTRYPOINT ["/entrypoint.sh"]
