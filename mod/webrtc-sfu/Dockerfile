ARG BBB_BUILD_TAG
FROM gitlab.senfcall.de:5050/senfcall-public/docker-bbb-build:$BBB_BUILD_TAG AS builder


RUN useradd --uid 2004 --user-group webrtc-sfu 

ADD ./bbb-webrtc-sfu /app


ENV NODE_ENV production

# due to the git submodule npm install crashes with following error:
# npm ERR! fatal: Not a git repository: ../.git/modules/bbb-webrtc-sfu
# we simply delete the .git file
RUN cd /app \
 && cp config/default.example.yml config/production.yml \
 && rm .git \
 && npm install --unsafe-perm \
 && npm cache clear --force \
 && rm -rf node_modules/mediasoup/worker/out/Release/subprojects \
 && rm -rf node_modules/mediasoup/worker/out/Release/mediasoup-worker.p \
 && rm -rf node_modules/mediasoup/worker/out/Release/deps


# =============================
FROM node:14.18.1-bullseye-slim
RUN useradd --uid 2004 --user-group webrtc-sfu 
ENV NODE_ENV production

COPY --from=builder /app /app
RUN chown -R webrtc-sfu:webrtc-sfu /app/config

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

USER webrtc-sfu
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
