FROM node:14-alpine AS builder

RUN apk add subversion git

# --------------------

ENV TAG_PLAYBACK v2.3.2
ENV REACT_APP_BBB_PLAYBACK_BUILD=$TAG_PLAYBACK

# apparently there is currently no github release & tag created
# for the latest bbb-playback version shipped with 2.3-alpha-6
# so we use the master branch 
# RUN svn checkout https://github.com/bigbluebutton/bbb-playback/tags/$TAG_PLAYBACK /bbb-playback
RUN git clone https://github.com/bigbluebutton/bbb-playback.git /bbb-playback && cd /bbb-playback && git checkout a9d3b7b6648fb5e85e012e73d7e7a2684d02f215
RUN cd /bbb-playback && npm install && npm run-script build

# --------------------

FROM nginx:1.19-alpine

COPY --from=builder /bbb-playback/build /www/playback/presentation/2.3
COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
