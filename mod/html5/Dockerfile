FROM node:12-buster-slim AS builder

ARG BBB_REPO_URL
ENV BBB_REPO_URL $BBB_REPO_URL
ARG BBB_BRANCH_OR_TAG
ENV BBB_BRANCH_OR_TAG $BBB_BRANCH_OR_TAG

# upgrade git so we have the sparse checkout and clone with filter feature
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git \
    && apt-get clean all

RUN apt-get update && apt-get install -y wget curl python3 build-essential
RUN groupadd -g 2000 meteor && useradd -m -u 2001 -g meteor meteor


# download dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

USER meteor
ENV METEOR_VERSION 1.10.2
RUN curl -sL https://install.meteor.com?release=$METEOR_VERSION | sed s/--progress-bar/-sL/g | /bin/sh

# clone only bigbluebutton-html5
RUN cd ~ \
    && git clone --filter=blob:none --no-checkout $BBB_REPO_URL \
    && cd bigbluebutton \
    && git sparse-checkout set bigbluebutton-html5 \
    && git checkout $BBB_BRANCH_OR_TAG -b docker-build

RUN cd ~ \
    && mv ~/bigbluebutton/bigbluebutton-html5 ~/source \
    && cd ~/source \
    && ~/.meteor/meteor npm install --production \
    && METEOR_DISABLE_OPTIMISTIC_CACHING=1  ~/.meteor/meteor build --directory ~/app \
    && rm -rf ~/source

RUN cd ~/app/bundle/programs/server \
    && npm install --production
    
# ------------------------------

FROM node:12-alpine

RUN addgroup -g 2000 meteor && \
    adduser -D -u 2001 -G meteor meteor && \
    apk add su-exec
COPY --from=builder /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=builder --chown=meteor:meteor /home/meteor/app/bundle /app
COPY entrypoint.sh /entrypoint.sh
COPY settings.yml /app/programs/server/assets/app/config/settings.yml.tmpl

ENTRYPOINT ["/entrypoint.sh"]

# lets set the tag again, so that it is include in the image for later version retrieval
ENV TAG BBB_BRANCH_OR_TAG
