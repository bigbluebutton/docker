ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

# RUN groupadd -g 2000 meteor && useradd -m -u 2001 -g meteor meteor
# USER meteor

ARG TAG_HTML5

COPY --from=source ./ /source
RUN cd /source && meteor npm ci --production \
    && METEOR_DISABLE_OPTIMISTIC_CACHING=1 meteor build --architecture os.linux.x86_64 --allow-superuser  --directory /app \
    && rm -rf /source

RUN cd /app/bundle/programs/server \
    && npm install --production
    
RUN mkdir -p /app/bundle/programs/web.browser/app/files && \
    cp /app/bundle/programs/server/npm/node_modules/@fontsource/*/files/*.woff* /app/bundle/programs/web.browser/app/files/

RUN sed -i "s/VERSION/$TAG_BBB/" /app/bundle/programs/web.browser/head.html \
    && find /app/bundle/programs/web.browser -name '*.js' -exec gzip -k -f -9 '{}' \; \
    && find /app/bundle/programs/web.browser -name '*.css' -exec gzip -k -f -9 '{}' \; \
    && find /app/bundle/programs/web.browser -name '*.wasm' -exec gzip -k -f -9 '{}' \;

# ------------------------------

FROM node:14.21-bullseye-slim

RUN apt-get update && apt-get install -y gosu

# add user & group
RUN groupadd -g 2000 meteor \
    && useradd -m -u 2001 -g meteor meteor

COPY --from=alangecker/bbb-docker-base-java /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=builder --chown=meteor:meteor /app/bundle /app
COPY entrypoint.sh /entrypoint.sh
COPY bbb-html5.yml /app/bbb-html5.yml.tmpl

# expose TAG_BBB in container for the version display
ARG TAG_BBB
ENV TAG_BBB $TAG_BBB

ENTRYPOINT ["/entrypoint.sh"]
