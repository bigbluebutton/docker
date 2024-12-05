ARG TAG_ETHERPAD
FROM etherpad/etherpad:$TAG_ETHERPAD

USER root

RUN apk add git curl

USER etherpad

RUN pnpm run plugins i \
    ep_cursortrace@3.1.18 \
    ep_disable_chat@0.0.10 \
    ep_auth_session@1.1.1 \
    --github \
        mconf/ep_pad_ttl#360136cd38493dd698435631f2373cbb7089082d \
        mconf/ep_redis_publisher#2b6e47c1c59362916a0b2961a29b259f2977b694


# add skin from git submodule
COPY --chown=etherpad:0 --from=skin / /opt/etherpad-lite/src/static/skins/bigbluebutton

# add plugin from git submodule
COPY --chown=etherpad:0 --from=plugin / /ep_bigbluebutton_patches
RUN pnpm run plugins i --path /ep_bigbluebutton_patches

COPY settings.json /opt/etherpad-lite/settings.json
COPY etherpad-export.sh /etherpad-export.sh
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]