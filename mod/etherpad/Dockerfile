ARG TAG_ETHERPAD
FROM etherpad/etherpad:$TAG_ETHERPAD

USER root

RUN apk add git curl

USER etherpad

RUN pnpm run plugins i \
    ep_disable_chat@0.0.13 \
    ep_auth_session@1.1.2 \
    --github \
        mconf/ep_cursortrace#56fb8c2b211cdda4fc8715ec99e1cb7b7d9eb851 \
        alangecker/ep_pad_ttl#3a3530b7f618e794d0bade34324d2af709b527ba \
        alangecker/ep_redis_publisher#b86ce4e07e4579bf2345be2a0e3fed59b6be92ba


# add skin from git submodule
COPY --chown=etherpad:0 --from=skin / /opt/etherpad-lite/src/static/skins/bigbluebutton

# add plugin from git submodule
COPY --chown=etherpad:0 --from=plugin / /ep_bigbluebutton_patches
RUN pnpm run plugins i --path /ep_bigbluebutton_patches

COPY settings.json /opt/etherpad-lite/settings.json
COPY etherpad-export.sh /etherpad-export.sh
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]