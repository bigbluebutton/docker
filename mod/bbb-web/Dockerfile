FROM mozilla/sbt:8u181_1.2.7 AS builder

ARG BBB_REPO_URL
ENV BBB_REPO_URL $BBB_REPO_URL
ARG BBB_BRANCH_OR_TAG
ENV BBB_BRANCH_OR_TAG $BBB_BRANCH_OR_TAG

# upgrade git so we have the sparse checkout and clone with filter feature
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git \
    && apt-get clean all

# clone only bbb-common-message and bbb-common-web and bigbluebutton-web subfolder
RUN git clone --filter=blob:none --no-checkout $BBB_REPO_URL \
    && cd bigbluebutton \
    && git sparse-checkout set bbb-common-message bbb-common-web bigbluebutton-web \
    && git checkout $BBB_BRANCH_OR_TAG -b docker-build

# compile and locally publish bbb-common-message
RUN cd bigbluebutton/bbb-common-message \
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

# locally publish bbb-common-web
RUN cd bigbluebutton/bbb-common-web \
 && ./deploy.sh

# compile bbb-web
RUN cd bigbluebutton/bigbluebutton-web && grails assemble

# compile pres-checker
RUN cd bigbluebutton/bigbluebutton-web/pres-checker && gradle resolveDeps

# extract .war
RUN unzip -q bigbluebutton/bigbluebutton-web/build/libs/bigbluebutton-0.10.0.war -d /dist


# ===================================================
FROM openjdk:8-jre-slim-buster

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
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


# add blank presentation files and allow conversation to pdf/svg
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && cd /usr/share/bigbluebutton/blank \
    && wget \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.3.0/bigbluebutton-config/slides/blank-svg.svg \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.3.0/bigbluebutton-config/slides/blank-thumb.png \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.3.0/bigbluebutton-config/slides/blank-presentation.pdf \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.3.0/bigbluebutton-config/slides/blank-png.png \
    && sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml

# get bbb-web
COPY --from=builder /dist /usr/share/bbb-web

# get pres-checker
COPY --from=builder /bigbluebutton/bigbluebutton-web/pres-checker/lib /usr/share/prescheck/lib
COPY --from=builder /bigbluebutton/bigbluebutton-web/pres-checker/run.sh /usr/share/prescheck/prescheck.sh

COPY mocked-ps /usr/bin/ps

# add entrypoint and templates
COPY entrypoint.sh /entrypoint.sh
COPY bbb-web.properties /etc/bigbluebutton/bbb-web.properties.tmpl
COPY turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl
COPY logback.xml /usr/share/bbb-web/WEB-INF/classes/logback.xml
COPY office-convert.sh /usr/share/bbb-libreoffice-conversion/convert.sh

ENTRYPOINT ["/entrypoint.sh"]
