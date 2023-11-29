FROM node:18-bullseye-slim AS builder

COPY --from=src / /bbb-pads
RUN cd /bbb-pads && rm -r .git && npm install --production


RUN chmod 777 /bbb-pads/config
# ------------------------------

FROM node:18-bullseye-slim

RUN apt update && apt install -y jq moreutils \
    && useradd --uid 2003 --create-home --user-group bbb-pads

COPY --from=builder /bbb-pads /bbb-pads
USER bbb-pads
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh