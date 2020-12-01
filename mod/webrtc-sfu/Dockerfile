FROM node:14-alpine

RUN apk update && apk add git

ADD . app

WORKDIR app

ENV NODE_ENV production


# due to the git submodule npm install crashes with following error:
# npm ERR! fatal: Not a git repository: ../.git/modules/bbb-webrtc-sfu
# we simply delete the .git file
RUN cp config/default.example.yml config/production.yml \
 && rm .git \
 && npm install --unsafe-perm \
 && npm cache clear --force

EXPOSE 3008

# remove automatic IP detection (broken in alpine)
# and use sh instead of bash
RUN sed -i 's/CONTAINER_IP=.*/CONTAINER_IP=10.7.7.10/' /app/docker-entrypoint.sh \
    && sed -i 's/bash/sh/' /app/docker-entrypoint.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
