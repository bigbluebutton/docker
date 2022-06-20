FROM debian:bullseye-slim

# -- install docker cli
COPY --from=library/docker:latest /usr/local/bin/docker /usr/bin/docker

COPY bbb-remove-old-recordings bbb-resync-freeswitch entrypoint.sh /

RUN chmod +x bbb-remove-old-recordings

ENTRYPOINT ["/entrypoint.sh"]
