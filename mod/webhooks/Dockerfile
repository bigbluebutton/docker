FROM node:18-bullseye-slim AS builder


RUN apt-get update && apt-get install -y git wget

RUN  wget -q https://github.com/mikefarah/yq/releases/download/v4.25.1/yq_linux_amd64 -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

COPY --from=src / /bbb-webhooks
RUN cd /bbb-webhooks && npm install --production

RUN chmod 777 /bbb-webhooks/config
# ------------------------------

FROM node:18-bullseye-slim
RUN useradd --uid 2004 --user-group bbb-webhooks

COPY --from=builder /usr/bin/yq /usr/bin/yq
COPY --from=builder /bbb-webhooks /bbb-webhooks
COPY entrypoint.sh /entrypoint.sh

RUN mkdir /bbb-webhooks/log && chmod 777 /bbb-webhooks/log
USER bbb-webhooks
ENTRYPOINT /entrypoint.sh

