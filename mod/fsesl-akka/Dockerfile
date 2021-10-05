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
ENV TAG_FSESL v2.3.14
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_FSESL/bbb-fsesl-client /bbb-fsesl-client \
    && rm -rf /bbb-fsesl-client/.svn

RUN cd /bbb-fsesl-client \
    && ./deploy.sh


ENV TAG v2.3.14
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/akka-bbb-fsesl /source \
    && rm -rf /source/.svn

# compile and unzip bin
RUN cd /source \
    && sbt universal:packageBin
RUN unzip /source/target/universal/bbb-fsesl-akka-0.0.2.zip -d /

# # ===================================================

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