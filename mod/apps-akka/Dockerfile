ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src-common-message / /bbb-common-message

# build bbb-common-message
RUN cd /bbb-common-message && ./deploy.sh

# ===================================================

ARG TAG_APPS_AKKA

COPY --from=src-apps-akka / /source

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
