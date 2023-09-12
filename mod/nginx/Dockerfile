ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

# --------------------

ARG TAG_LEARNING_DASHBOARD
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_LEARNING_DASHBOARD/bbb-learning-dashboard /bbb-learning-dashboard && rm -r /bbb-learning-dashboard/.svn
RUN cd /bbb-learning-dashboard && npm ci && npm run build

COPY ./bbb-playback /bbb-playback
RUN cd /bbb-playback && npm ci && npm run build

# --------------------

FROM nginx:1.23-alpine

COPY --from=builder /bbb-learning-dashboard/build /www/learning-analytics-dashboard/
COPY --from=builder /bbb-playback/build /www/playback/presentation/2.3
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
