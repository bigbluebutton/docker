ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

RUN mkdir -p /hasura-cli && cd /hasura-cli && npm install hasura-cli
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod a+x /usr/local/bin/yq

# ----------------------------
FROM hasura/graphql-engine:v2.36.0

# install netstat
RUN apt-get update && apt-get install -y net-tools gosu

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /hasura-cli/node_modules/hasura-cli/hasura /usr/local/bin/hansura

COPY --from=src /bbb_schema.sql /app/
COPY --from=src /metadata /app/metadata

COPY config.yaml /app/config.yaml
COPY entrypoint.sh /entrypoint.sh
COPY start.sh /app/start.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/app/start.sh" ]
