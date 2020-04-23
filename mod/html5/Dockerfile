# TODO: build from github repo with node:12
FROM node:8-stretch

ENV NODE_ENV production
ENV DOCKERIZE_VERSION v0.6.1

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN apt-get update &&  apt-get install -y wget binutils
RUN useradd -m meteor

# download & install bbb-html5 package manually
RUN PACKAGE_PATH=$(curl -s https://ubuntu.bigbluebutton.org/xenial-220/dists/bigbluebutton-xenial/main/binary-amd64/Packages | grep -E 'Filename.*html5' | awk '{print $2}') \
    && wget https://ubuntu.bigbluebutton.org/xenial-220/$PACKAGE_PATH \
    && ar x bbb-html5_*.deb \
    && tar -zxf data.tar.gz ./usr/share/meteor/bundle \
    && mv /usr/share/meteor/bundle /app \
    && rm -rf /app/programs/server/node_modules \
    && chown meteor:meteor /app/programs/server \
    && chown -R meteor:meteor /app/programs/server/assets/app/config \
    && rm /*.deb /*.tar.gz

USER meteor
RUN cd /app/programs/server && npm install && npm cache clear --force


COPY entrypoint.sh /entrypoint.sh
COPY settings.yml /app/programs/server/assets/app/config/settings.yml.tmpl

ENTRYPOINT ["/entrypoint.sh"]
