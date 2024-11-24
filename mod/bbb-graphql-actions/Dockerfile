ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src ./ /src
RUN cd /src && \
    npm ci --no-progress && \
    npm run build

# delete node_modules (it should create a fresh one inside /src/dist/)
RUN rm -rf /src/node_modules

RUN cd /src/dist && \
    mv index.js bbb-graphql-actions.js && \
    cp ../package.json ../package-lock.json . && \
    npm ci --no-progress --omit=dev


# ------------------------------
FROM node:22-bookworm-slim

COPY --from=builder /src/dist /app

RUN groupadd -g 2062 app \
    && useradd -m -u 2063 -g app app

USER app

WORKDIR /app

ENV SERVER_HOST 0.0.0.0

ENV NODE_ENV=production

CMD [ "node", "/app/bbb-graphql-actions.js" ]