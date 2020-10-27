FROM openjdk:8u252-jdk-slim-buster

RUN apt update && apt-get install -y subversion wget gosu

# install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV TAG v2.3-alpha-2

RUN cd / \
    && svn checkout https://github.com/alangecker/bbb-packages/tags/$TAG/bbb-apps-akka/data/usr/share/bbb-apps-akka \
    && rm -r /bbb-apps-akka/.svn

RUN groupadd -g 998 bigbluebutton \
    && useradd -m -u 998 -g bigbluebutton bigbluebutton \
    && rm /bbb-apps-akka/logs \
    && mkdir /bbb-apps-akka/logs \
    && ln -s /dev/null /bbb-apps-akka/logs/bbb-apps-akka.log

COPY application.conf /bbb-apps-akka/conf/application.conf.tmpl

WORKDIR /bbb-apps-akka
CMD dockerize \
    -template /bbb-apps-akka/conf/application.conf.tmpl:/bbb-apps-akka/conf/application.conf \
    gosu bigbluebutton /bbb-apps-akka/bin/bbb-apps-akka