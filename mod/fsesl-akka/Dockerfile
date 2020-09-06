FROM openjdk:8u252-jdk-slim-buster

RUN apt update && apt-get install -y subversion 

ENV TAG v2.3-alpha-2


RUN cd / \
    && svn checkout https://github.com/alangecker/bbb-packages/tags/$TAG/bbb-fsesl-akka/data/usr/share/bbb-fsesl-akka \
    && rm -r /bbb-fsesl-akka/.svn \
    && groupadd -g 2003 fsesl \
    && useradd -m -u 2003 -g fsesl fsesl \
    && rm /bbb-fsesl-akka/logs \
    && mkdir /bbb-fsesl-akka/logs \
    && ln -s /dev/null /bbb-fsesl-akka/logs/bbb-fsesl-akka.log

COPY application.conf /bbb-fsesl-akka/conf/application.conf

USER fsesl
WORKDIR /bbb-fsesl-akka
CMD /bbb-fsesl-akka/bin/bbb-fsesl-akka