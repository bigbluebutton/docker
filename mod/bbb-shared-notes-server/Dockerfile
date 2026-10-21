FROM node:24-trixie-slim AS builder

COPY --from=src / /bbb-shared-notes-server
RUN cd /bbb-shared-notes-server && npm ci --no-progress
RUN cd /bbb-shared-notes-server && npm run build

RUN cd /bbb-shared-notes-server/ && \
    mv dist/index.js dist/bbb-shared-notes-server.js && \
    cp blocknote_schema.sql dist/ && \
    cp package.json dist/ && \
    cp package-lock.json dist/ && \
    mkdir dist/config && \
    cp config/default.yml dist/config/ && \
    cp -r node_modules dist/ && \
    cp -r assets dist/


RUN chmod 777 /bbb-shared-notes-server/config
# ------------------------------

# wkhtmltopdf is not available on trixie
FROM node:24-bookworm-slim

RUN apt update && apt install -y wkhtmltopdf postgresql-client \
    && useradd --uid 2004 --create-home --user-group bbb-shared-notes-server

COPY --from=builder /bbb-shared-notes-server/dist /usr/share/bbb-shared-notes-server
COPY config.yaml /etc/bigbluebutton/bbb-shared-notes-server.yml
COPY entrypoint.sh /entrypoint.sh
USER bbb-shared-notes-server
WORKDIR /usr/share/bbb-shared-notes-server
ENV NODE_ENV=production
ENTRYPOINT /entrypoint.sh
