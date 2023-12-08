ARG TAG_ETHERPAD
FROM etherpad/etherpad:$TAG_ETHERPAD

USER root

RUN apk add git curl

USER etherpad

RUN npm install \
    ep_cursortrace@3.1.16 \
    git+https://github.com/mconf/ep_pad_ttl.git#360136cd38493dd698435631f2373cbb7089082d \
    git+https://github.com/mconf/ep_redis_publisher.git#2b6e47c1c59362916a0b2961a29b259f2977b694 \
    ep_disable_chat@0.0.8 \
    ep_auth_session@1.1.1 \
# remove npm lockfile, because somehow it prevents etherpad from detecting the manual added plugin ep_bigbluebutton_patches
    && rm package-lock.json package.json

# add skin from git submodule
COPY --chown=etherpad:0 --from=skin / /opt/etherpad-lite/src/static/skins/bigbluebutton

# add plugin from git submodule
COPY --chown=etherpad:0 --from=plugin / /opt/etherpad-lite/node_modules/ep_bigbluebutton_patches

COPY settings.json /opt/etherpad-lite/settings.json
COPY etherpad-export.sh /etherpad-export.sh
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]