ARG BBB_BUILD_TAG
FROM gitlab.senfcall.de:5050/senfcall-public/docker-bbb-build:$BBB_BUILD_TAG AS builder

ARG TAG_COMMON_MESSAGE

# download bbb-common-message
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_COMMON_MESSAGE/bbb-common-message /bbb-common-message \
    && cd /bbb-common-message \
    && ./deploy.sh \
    && rm -rf /bbb-common-message

# ===================================================

ARG TAG_APPS_AKKA

RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_APPS_AKKA/akka-bbb-apps /source \
    && rm -rf /source/.svn

# compile and unzip bin
RUN cd /source \
    && sbt universal:packageBin \
    && unzip /source/target/universal/bbb-apps-akka-0.0.4.zip -d /

# ===================================================

FROM alangecker/bbb-docker-base-java

COPY --from=builder /bbb-apps-akka-0.0.4 /bbb-apps-akka
COPY bbb-apps-akka.conf /etc/bigbluebutton/bbb-apps-akka.conf.tmpl
COPY logback.xml /bbb-apps-akka/conf/logback.xml
COPY entrypoint.sh /entrypoint.sh

USER bigbluebutton
ENTRYPOINT /entrypoint.sh
