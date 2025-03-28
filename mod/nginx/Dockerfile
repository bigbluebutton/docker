ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder-learning-dashboard
COPY --from=src-learning-dashboard / /bbb-learning-dashboard
RUN cd /bbb-learning-dashboard && npm ci && npm run build


FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder-playback
COPY --from=src-playback / /bbb-playback
RUN cd /bbb-playback && npm install && npm run-script build

FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder-html5
COPY --from=src-html5 / /source
RUN cd /source && CI=true npm ci
RUN cd /source && DISABLE_ESLINT_PLUGIN=true npm run build-safari && npm run build
RUN cd /source/dist && \
    HASH=$(ls | grep -Eo 'bundle\.[a-f0-9]{20}\.js' | head -n 1 | grep -Eo '[a-f0-9]{20}') && \
    if [ -z "$HASH" ]; then \
      echo "Bundle hash not found."; \
    else \
      for FILE in *.safari.js *.safari.js.map; do \
        if [[ "$FILE" == *"$HASH"* ]]; then \
          continue; \
        fi; \
        PREFIX="${FILE%%.safari.js*}"; \
        SUFFIX="${FILE#*.safari.js}"; \
        NEW_NAME="${PREFIX}.${HASH}.safari.js${SUFFIX}"; \
        echo "Renaming $FILE → $NEW_NAME"; \
        mv "$FILE" "$NEW_NAME"; \
      done; \
    fi

RUN find /source/dist -name '*.js' -exec gzip -k -f -9 '{}' \; \
    && find /source/dist -name '*.css' -exec gzip -k -f -9 '{}' \; \
    && find /source/dist -name '*.wasm' -exec gzip -k -f -9 '{}' \;

RUN sed -i "s/VERSION/$BBB_BUILD_TAG/g" /source/dist/index.html && \
    sed -i "s/VERSION/$BBB_BUILD_TAG/g" /source/dist/stylesheets/fonts.css

# --------------------

FROM nginx:1.27-alpine

COPY --from=builder-learning-dashboard /bbb-learning-dashboard/build /www/learning-analytics-dashboard/
COPY --from=builder-playback /bbb-playback/build /www/playback/presentation/2.3
COPY --from=builder-html5 /source/dist /usr/share/bigbluebutton/html5-client/
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./bbb-graphql-client-settings-cache.conf /etc/nginx/conf.d/bbb-graphql-client-settings-cache.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
