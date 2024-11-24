ARG BBB_BUILD_TAG
ARG GRAPHQL_ENGINE_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | INSTALL_PATH=/usr/local/bin VERSION=v2.44.0 bash
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod a+x /usr/local/bin/yq

# ----------------------------
FROM hasura/graphql-engine:$GRAPHQL_ENGINE_TAG

# install netstat, required for start script
RUN apt-get update && apt-get install -y net-tools gosu

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/hasura /usr/local/bin/hasura

COPY --from=src /bbb_schema.sql /app/
COPY --from=src /metadata /app/metadata

COPY config.yaml /app/config.yaml
COPY entrypoint.sh /entrypoint.sh
COPY start.sh /app/start.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/app/start.sh" ]
