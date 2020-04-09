# TODO: build from github repo with node:12
FROM node:8-stretch

ENV NODE_ENV production

RUN  apt-get update &&  apt-get install -y sudo wget binutils

RUN useradd -m meteor

RUN wget https://ubuntu.bigbluebutton.org/xenial-220/pool/main/b/bbb-html5/bbb-html5_2.2.0-870_amd64.deb \
    && ar x bbb-html5_*.deb \
    && tar -zxf data.tar.gz ./usr/share/meteor/bundle \
    && mv /usr/share/meteor/bundle /app \
    && rm -rf /app/programs/server/node_modules \
    && chown meteor:meteor /app/programs/server \
    && rm /*.deb /*.tar.gz

USER meteor
RUN cd /app/programs/server && npm install && npm cache clear --force


COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
