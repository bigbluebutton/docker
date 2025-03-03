ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder


RUN useradd --uid 2004 --user-group webrtc-sfu 

# cache packages
COPY --from=source /package.json /cache/package.json
RUN cd /cache && npm install --unsafe-perm

COPY --from=source / /app

ENV NODE_ENV production


RUN cd /app \
  && rm -rf /app/node_modules && cp -a /cache/node_modules /app/node_modules \
 && cp config/default.example.yml config/production.yml \
 && npm install --unsafe-perm \
 && npm cache clear --force \
 && rm -rf node_modules/mediasoup/worker/out/Release/subprojects \
 && rm -rf node_modules/mediasoup/worker/out/Release/mediasoup-worker.p \
 && rm -rf node_modules/mediasoup/worker/out/Release/deps


# =============================
FROM node:22-bookworm-slim
RUN useradd --uid 2004 --user-group webrtc-sfu 
ENV NODE_ENV production

COPY --from=builder /app /app
RUN mkdir /home/webrtc-sfu && chown -R webrtc-sfu:webrtc-sfu /app/config /home/webrtc-sfu

USER webrtc-sfu
WORKDIR /app


COPY config.yaml /etc/bigbluebutton/bbb-webrtc-sfu/production.yml
ENV NODE_ENV=production
ENV NODE_CONFIG_DIR=/app/config/:/etc/bigbluebutton/bbb-webrtc-sfu/
ENV ALLOW_CONFIG_MUTATIONS=true
CMD [ "npm", "start" ]
