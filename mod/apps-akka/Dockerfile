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


FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder-settings
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64 && chmod a+x /usr/local/bin/yq
COPY --from=src-config /settings.yml /settings.yml
ARG TAG_BBB
RUN yq e -i ".public.app.bbbServerVersion = \"$TAG_BBB\"" /settings.yml
RUN yq e -i ".public.app.html5ClientBuild = \"$TAG_BBB\"" /settings.yml


# ===================================================

FROM alangecker/bbb-docker-base-java

COPY --from=builder-settings /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /bbb-apps-akka-0.0.4 /bbb-apps-akka
COPY bbb-apps-akka.conf /etc/bigbluebutton/bbb-apps-akka.conf.tmpl
COPY logback.xml /bbb-apps-akka/conf/logback.xml
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder-settings --chown=bigbluebutton:bigbluebutton /settings.yml /usr/share/bigbluebutton/html5-client/private/config/settings.yml

USER bigbluebutton
ENTRYPOINT /entrypoint.sh
