ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src-common-message / /bbb-common-message

# build bbb-common-message
RUN cd /bbb-common-message && ./deploy.sh

# ===================================================


COPY --from=src-common-web / /bbb-common-web
# build bbb-common-web
RUN cd /bbb-common-web && ./deploy.sh

COPY --from=src-web / /bbb-web

# compile bbb-web
RUN cd /bbb-web && grails assemble

# compile pres-checker
RUN cd /bbb-web/pres-checker && gradle resolveDeps

# extract .war
RUN unzip -q /bbb-web/build/libs/bigbluebutton-0.10.0.war -d /dist


# ===================================================
FROM alangecker/bbb-docker-base-java

# add blank presentation files and allow conversion to pdf/svg
RUN mkdir -p /usr/share/bigbluebutton/blank \
    && cd /usr/share/bigbluebutton/blank \
    && wget \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-svg.svg \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-thumb.png \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-presentation.pdf \
        https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/v2.4.0/bigbluebutton-config/slides/blank-png.png \
    && sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml \
    && sed -i '/potrace/d' /etc/ImageMagick-6/delegates.xml


# get bbb-web
COPY --from=builder /dist /usr/share/bbb-web

# get pres-checker
COPY --from=builder /bbb-web/pres-checker/lib /usr/share/prescheck/lib
COPY --from=builder /bbb-web/pres-checker/run.sh /usr/share/prescheck/prescheck.sh

COPY mocked-ps /usr/bin/ps

# add entrypoint and templates
COPY entrypoint.sh /entrypoint.sh
COPY bbb-web.properties /etc/bigbluebutton/bbb-web.properties.tmpl
COPY turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl
COPY logback.xml /usr/share/bbb-web/WEB-INF/classes/logback.xml
COPY office-convert.sh /usr/share/bbb-libreoffice-conversion/convert.sh

ENTRYPOINT ["/entrypoint.sh"]
