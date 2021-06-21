FROM node:12-alpine

# download dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apk add subversion \
    && mkdir /app \
    && adduser -D -u 2002 -g webhooks webhooks \
    && chown webhooks:webhooks /app

USER webhooks


ENV TAG v2.3.4
RUN svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/bbb-webhooks /app \
    && rm -rf /app/.svn \
    && cd /app && npm install --production

COPY entrypoint.sh /entrypoint.sh
COPY config.yml /app/config/default.yml.tmpl

ENTRYPOINT /entrypoint.sh


