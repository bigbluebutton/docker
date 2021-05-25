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

# clone only bbb-common-message and akkas-bbb-apps subfolder
RUN git clone --filter=blob:none --no-checkout $BBB_REPO_URL \
    && cd bigbluebutton \
    && git sparse-checkout set bbb-common-message akka-bbb-apps \
    && git checkout $BBB_BRANCH_OR_TAG -b docker-build

# compile and locally publish bbb-common-message
RUN cd bigbluebutton/bbb-common-message \
    && ./deploy.sh

# compile and package akka-bbb-apps
RUN cd bigbluebutton/akka-bbb-apps \
    && sbt universal:packageBin \
    && unzip target/universal/bbb-apps-akka-0.0.4.zip -d /

# ===================================================

FROM openjdk:8-jre-slim-buster

RUN apt update && apt-get install -y wget gosu

# install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN groupadd -g 998 bigbluebutton \
    && useradd -m -u 998 -g bigbluebutton bigbluebutton

COPY --from=builder /bbb-apps-akka-0.0.4 /bbb-apps-akka
COPY bbb-apps-akka.conf /etc/bigbluebutton/bbb-apps-akka.conf.tmpl
COPY logback.xml /bbb-apps-akka/conf/logback.xml

WORKDIR /bbb-apps-akka
CMD dockerize \
    -template /etc/bigbluebutton/bbb-apps-akka.conf.tmpl:/etc/bigbluebutton/bbb-apps-akka.conf \
    gosu bigbluebutton /bbb-apps-akka/bin/bbb-apps-akka