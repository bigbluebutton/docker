FROM etherpad/etherpad:1.8.7

USER root

RUN apt-get update \
    && apt-get install -y git

USER etherpad

RUN npm install  \
    ep_delete_after_delay_lite \
    git+https://git@github.com/pedrobmarin/ep_redis_publisher.git

# add skin from git submodule
COPY --chown=etherpad:0 ./bbb-etherpad-skin /opt/etherpad-lite/src/static/skins/bigbluebutton

# add plugin from git submodule
COPY --chown=etherpad:0 ./bbb-etherpad-plugin /opt/etherpad-lite/node_modules/ep_bigbluebutton_patches

COPY settings.json /opt/etherpad-lite/settings.json
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]