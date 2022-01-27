FROM node:14-alpine AS builder

RUN apk add subversion git

# --------------------

ENV TAG_LEARNING_DASHBOARD v2.4.1
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_LEARNING_DASHBOARD/bbb-learning-dashboard /bbb-learning-dashboard && rm -r /bbb-learning-dashboard/.svn
RUN cd /bbb-learning-dashboard && npm ci && npm run build

ENV TAG_PLAYBACK v3.1.0
ENV REACT_APP_BBB_PLAYBACK_BUILD=$TAG_PLAYBACK
RUN svn checkout https://github.com/bigbluebutton/bbb-playback/tags/$TAG_PLAYBACK /bbb-playback && rm -r /bbb-playback/.svn
RUN cd /bbb-playback && npm ci && npm run build

# --------------------

FROM nginx:1.21-alpine

COPY --from=builder /bbb-learning-dashboard/build /www/learning-analytics-dashboard/
COPY --from=builder /bbb-playback/build /www/playback/presentation/2.3
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
