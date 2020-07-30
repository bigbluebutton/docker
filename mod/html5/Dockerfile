FROM node:8-buster-slim AS builder

RUN apt-get update && apt-get install -y wget curl subversion python2 python3 build-essential
RUN groupadd -g 2000 meteor && useradd -m -u 2001 -g meteor meteor


# download dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

USER meteor
ENV METEOR_VERSION 1.8.1
RUN curl -sL https://install.meteor.com?release=$METEOR_VERSION | sed s/--progress-bar/-sL/g | /bin/sh

ENV TAG v2.2.21
RUN cd ~ \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/bigbluebutton-html5 \
    && mv ~/bigbluebutton-html5 ~/source \
    && rm -rf ~/source/.svn

# source modifications for node v12 support:
# - remove memwatch since it is not available for node v12 and disabled anyway
# - set meteor release to 1.9
# - install newer fibers version (4.0.3) which supports node v12

# RUN sed -i -r 's/import (memwatch|heapdump).*//g' ~/source/imports/startup/server/index.js \
#     && sed -i -r 's/.*(memwatch|heapdump).*//g' ~/source/package.json \
#     && echo "METEOR@$METEOR_VERSION" > ~/source/.meteor/release \
#     && cat ~/source/.meteor/release

RUN cd ~/source \
    && ~/.meteor/meteor npm install --production \
    && ~/.meteor/meteor build --directory ~/app \
    && rm -r ~/source

RUN cd ~/app/bundle/programs/server \
    && npm install --production
    
# ------------------------------

FROM node:8-alpine

RUN addgroup -g 2000 meteor && adduser -D -u 2001 -G meteor meteor
COPY --from=builder /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=builder --chown=meteor:meteor /home/meteor/app/bundle /app
COPY entrypoint.sh /entrypoint.sh
COPY settings.yml /app/programs/server/assets/app/config/settings.yml.tmpl
USER meteor
ENTRYPOINT ["/entrypoint.sh"]

# lets set the tag again, so that it is include in the image for later version retrieval
ENV TAG v2.2.21
