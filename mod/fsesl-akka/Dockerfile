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

# clone only bbb-common-message and bbb-fsesl-client subfolder
RUN git clone --filter=blob:none --no-checkout $BBB_REPO_URL \
    && cd bigbluebutton \
    && git sparse-checkout set bbb-common-message bbb-fsesl-client akka-bbb-fsesl \
    && git checkout $BBB_BRANCH_OR_TAG -b docker-build

# compile and locally publish bbb-common-message
RUN cd bigbluebutton/bbb-common-message \
    && ./deploy.sh

# compile and package bbb-fsesl-client
RUN cd bigbluebutton/bbb-fsesl-client \
    && ./deploy.sh

# compile and unzip bin akka-bbb-fsesl
RUN cd bigbluebutton/akka-bbb-fsesl \
    && sbt universal:packageBin
RUN unzip bigbluebutton/akka-bbb-fsesl/target/universal/bbb-fsesl-akka-0.0.2.zip -d /

FROM openjdk:8-jre-slim-buster

RUN apt update && apt-get install -y wget gosu

# install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


RUN groupadd -g 1007 fsesl-akka \
    && useradd -m -u 1007 -g fsesl-akka fsesl-akka

COPY --from=builder /bbb-fsesl-akka-0.0.2 /bbb-fsesl-akka
COPY bbb-fsesl-akka.conf /etc/bigbluebutton/bbb-fsesl-akka.conf.tmpl
COPY logback.xml /bbb-fsesl-akka/conf/logback.xml

WORKDIR /bbb-fsesl-akka
CMD dockerize \
    -template /etc/bigbluebutton/bbb-fsesl-akka.conf.tmpl:/etc/bigbluebutton/bbb-fsesl-akka.conf \
    gosu fsesl-akka /bbb-fsesl-akka/bin/bbb-fsesl-akka