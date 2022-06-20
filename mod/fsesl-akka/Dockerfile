ARG BBB_BUILD_TAG
FROM gitlab.senfcall.de:5050/senfcall-public/docker-bbb-build:$BBB_BUILD_TAG AS builder

ARG TAG_COMMON_MESSAGE

# download bbb-common-message
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_COMMON_MESSAGE/bbb-common-message /bbb-common-message \
    && cd /bbb-common-message \
    && ./deploy.sh \
    && rm -rf /bbb-common-message

# ===================================================
ARG TAG_FSESL_AKKA
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_FSESL_AKKA/bbb-fsesl-client /bbb-fsesl-client \
    && rm -rf /bbb-fsesl-client/.svn

RUN cd /bbb-fsesl-client \
    && ./deploy.sh

RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_FSESL_AKKA/akka-bbb-fsesl /source \
    && rm -rf /source/.svn

# compile and unzip bin
RUN cd /source \
    && sbt universal:packageBin
RUN unzip /source/target/universal/bbb-fsesl-akka-0.0.2.zip -d /

# # ===================================================

FROM alangecker/bbb-docker-base-java

COPY --from=builder /bbb-fsesl-akka-0.0.2 /bbb-fsesl-akka
COPY bbb-fsesl-akka.conf /etc/bigbluebutton/bbb-fsesl-akka.conf.tmpl
COPY logback.xml /bbb-fsesl-akka/conf/logback.xml
COPY entrypoint.sh /entrypoint.sh

USER bigbluebutton
ENTRYPOINT /entrypoint.sh