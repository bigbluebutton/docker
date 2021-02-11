FROM node:14-alpine

RUN apk add git \
    && adduser -D -u 2004 -g webrtc-sfu webrtc-sfu

ADD ./bbb-webrtc-sfu app

WORKDIR app

ENV NODE_ENV production


# due to the git submodule npm install crashes with following error:
# npm ERR! fatal: Not a git repository: ../.git/modules/bbb-webrtc-sfu
# we simply delete the .git file
RUN cp config/default.example.yml config/production.yml \
 && chown -R webrtc-sfu:webrtc-sfu config \
 && rm .git \
 && npm install --unsafe-perm \
 && npm cache clear --force

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

USER webrtc-sfu
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
