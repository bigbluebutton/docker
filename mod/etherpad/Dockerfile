FROM etherpad/etherpad:1.8.6

USER root

# install etherpad plugins
# - ep_delete_after_delay_lite
# - ep_redis_publisher
RUN apt-get update \
    && apt-get install -y git \
    && npm install ep_delete_after_delay_lite  git+https://git@github.com/pedrobmarin/ep_redis_publisher.git

# apply "Including more data at pad update event"
# https://github.com/mconf/etherpad-lite/commit/5bc37fc92714e82165386dc0a5dd467609169a87
# this is a necessary patch for the closed captions
RUN sed -i "s|hooks\.callAll(\"padUpdate\".*)|hooks\.callAll(\"padUpdate\", {'pad':this, 'author': author, 'revs': newRev, 'changeset': aChangeset});|" /opt/etherpad-lite/src/node/db/Pad.js

COPY settings.json /opt/etherpad-lite/settings.json
COPY entrypoint.sh /entrypoint.sh

USER etherpad
ENTRYPOINT ["/entrypoint.sh"]