FROM nginx:1.19-alpine

RUN apk add subversion

ENV TAG v2.3-alpha-3

# get bbb-playback-presentation web files
RUN mkdir /www \
    && cd /www \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/record-and-playback/presentation/playback/presentation/ \
    && rm -rf /www/presentation/.svn /www/presentation/0.*

COPY ./bbb /etc/nginx/bbb
COPY ./bigbluebutton /etc/nginx/conf.d/default.conf