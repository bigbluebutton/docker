FROM node:14-alpine AS builder

RUN apk add subversion

# --------------------

ENV TAG_PlAYBACK_LEGACY v2.3-alpha-6
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_PlAYBACK_LEGACY/record-and-playback/presentation/playback/presentation /playback-legacy

# --------------------

ENV TAG_PLAYBACK v2.3.2
ENV REACT_APP_BBB_PLAYBACK_BUILD=$TAG_PLAYBACK

# apparently there is currently no github release & tag created
# for the latest bbb-playback version shipped with 2.3-alpha-6
# so we use the master branch 
# RUN svn checkout https://github.com/bigbluebutton/bbb-playback/tags/$TAG_PLAYBACK /bbb-playback
RUN svn checkout https://github.com/bigbluebutton/bbb-playback/trunk /bbb-playback
RUN cd /bbb-playback && npm install && npm run-script build

# --------------------

FROM nginx:1.19-alpine

COPY --from=builder /playback-legacy/2.0 /www/presentation/2.0
COPY --from=builder /bbb-playback/build /www/presentation/2.3
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf