FROM node:14-bullseye-slim


RUN apt-get update && apt-get -y install \
  git \
  make \
  python \
  python3-pip \
  g++ \
  ffmpeg

RUN useradd --uid 2004 --user-group webrtc-sfu 

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
 && npm cache clear --force \
 && rm -rf node_modules/mediasoup/worker/out/Release/subprojects \
 && rm -rf node_modules/mediasoup/worker/out/Release/mediasoup-worker.p \
 && rm -rf node_modules/mediasoup/worker/out/Release/deps
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

USER webrtc-sfu
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
