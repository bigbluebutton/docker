ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

# --------------------

COPY --from=src-learning-dashboard / /bbb-learning-dashboard
RUN cd /bbb-learning-dashboard && npm ci && npm run build

COPY --from=src-playback / /bbb-playback
RUN cd /bbb-playback && npm install && npm run-script build

# --------------------

FROM nginx:1.25-alpine

COPY --from=builder /bbb-learning-dashboard/build /www/learning-analytics-dashboard/
COPY --from=builder /bbb-playback/build /www/playback/presentation/2.3
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
