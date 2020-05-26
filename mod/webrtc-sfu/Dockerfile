FROM node:12-alpine

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

ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
