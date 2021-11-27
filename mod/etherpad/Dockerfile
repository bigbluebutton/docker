FROM etherpad/etherpad:1.8.14 
# TODO: update to 1.8.15 as soon as available

USER root

RUN apt-get update \
    && apt-get install -y git curl

USER etherpad

# only used to trigger a fresh run of the npm install
# command without caching
ENV TAG v2.4-rc-5

# ep_cursortrace: using mconf's fork due to https://github.com/ether/ep_cursortrace/pull/25 not being accepted upstream
RUN npm install  \
    git+https://github.com/mconf/ep_cursortrace.git \
    git+https://git@github.com/pedrobmarin/ep_pad_ttl.git \
    git+https://git@github.com/pedrobmarin/ep_redis_publisher.git \
    git+https://git@github.com/ether/ep_disable_chat.git \
    git+https://github.com/ether/ep_sticky_attributes.git \
# remove npm lockfile, because somehow it prevents etherpad from detecting the manual added plugin ep_bigbluebutton_patches
    && rm package-lock.json

# add skin from git submodule
COPY --chown=etherpad:0 ./bbb-etherpad-skin /opt/etherpad-lite/src/static/skins/bigbluebutton

# add plugin from git submodule
COPY --chown=etherpad:0 ./bbb-etherpad-plugin /opt/etherpad-lite/node_modules/ep_bigbluebutton_patches

COPY settings.json /opt/etherpad-lite/settings.json
COPY etherpad-export.sh /etherpad-export.sh
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]