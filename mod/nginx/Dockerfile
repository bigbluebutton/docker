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
RUN cd /source && DISABLE_ESLINT_PLUGIN=true npm run build
RUN find /source/dist -name '*.js' -exec gzip -k -f -9 '{}' \; \
    && find /source/dist -name '*.css' -exec gzip -k -f -9 '{}' \; \
    && find /source/dist -name '*.wasm' -exec gzip -k -f -9 '{}' \;

# --------------------

FROM nginx:1.25-alpine

COPY --from=builder-learning-dashboard /bbb-learning-dashboard/build /www/learning-analytics-dashboard/
COPY --from=builder-playback /bbb-playback/build /www/playback/presentation/2.3
COPY --from=builder-html5 /source/dist /usr/share/bigbluebutton/html5-client/
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./bbb-graphql-client-settings-cache.conf /etc/nginx/conf.d/bbb-graphql-client-settings-cache.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
