ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder


RUN useradd --uid 2004 --user-group webrtc-sfu 

COPY --from=source / /app

ENV NODE_ENV production

RUN cd /app \
 && cp config/default.example.yml config/production.yml \
 && npm install --unsafe-perm \
 && npm cache clear --force \
 && rm -rf node_modules/mediasoup/worker/out/Release/subprojects \
 && rm -rf node_modules/mediasoup/worker/out/Release/mediasoup-worker.p \
 && rm -rf node_modules/mediasoup/worker/out/Release/deps


# =============================
FROM node:18-bullseye-slim
RUN useradd --uid 2004 --user-group webrtc-sfu 
ENV NODE_ENV production

COPY --from=builder /app /app
RUN mkdir /home/webrtc-sfu && chown -R webrtc-sfu:webrtc-sfu /app/config /home/webrtc-sfu

USER webrtc-sfu
WORKDIR /app
CMD [ "npm", "start" ]
