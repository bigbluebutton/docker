FROM debian:buster-slim

# -- install mongo cli
RUN apt-get update \
    && apt-get install -y wget libcurl4 \
    && wget https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.2/main/binary-amd64/mongodb-org-shell_4.2.6_amd64.deb \
    && dpkg -i mongodb*.deb \
    && rm mongodb*.deb

# -- install docker cli
COPY --from=library/docker:latest /usr/local/bin/docker /usr/bin/docker

COPY bbb-restart-kms bbb-resync-freeswitch entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]