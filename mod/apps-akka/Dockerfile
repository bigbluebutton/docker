FROM mozilla/sbt:8u181_1.2.7 AS builder

RUN apt-get update && apt-get install -y subversion

# download bbb-common-message
ENV TAG_COMMON_MESSAGE v2.3.14
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_COMMON_MESSAGE/bbb-common-message /bbb-common-message \
    && rm -rf /bbb-common-message/.svn

# compile bbb-common-message
RUN cd /bbb-common-message \
 && ./deploy.sh 


# ===================================================

ENV TAG v2.3.14
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/akka-bbb-apps /source \
    && rm -rf /source/.svn

# compile and unzip bin
RUN cd /source \
    && sbt universal:packageBin \
    && unzip /source/target/universal/bbb-apps-akka-0.0.4.zip -d /

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