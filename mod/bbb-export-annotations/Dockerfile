FROM node:22-bookworm-slim AS builder

COPY --from=src / /bbb-export-annotations
RUN cd /bbb-export-annotations && npm ci && npm install

# --------------------

FROM node:22-bookworm-slim

RUN groupadd -g 998 bigbluebutton \
    && useradd -m -u 998 -g bigbluebutton bigbluebutton

RUN apt update && apt install -y \
    nodejs npm cairosvg ghostscript imagemagick nodejs poppler-utils

COPY --from=builder /bbb-export-annotations /bbb-export-annotations
COPY ./config/settings.json /bbb-export-annotations/config/settings.json

USER bigbluebutton
WORKDIR /bbb-export-annotations
ENV NODE_ENV=production

ENTRYPOINT npm start
