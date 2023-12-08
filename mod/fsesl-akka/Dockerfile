ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src-common-message / /bbb-common-message

# build bbb-common-message
RUN cd /bbb-common-message && ./deploy.sh

# ===================================================
COPY --from=src-fsesl-client / /bbb-fsesl-client
RUN cd /bbb-fsesl-client && ./deploy.sh

COPY --from=src-fsesl-akka / /source

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