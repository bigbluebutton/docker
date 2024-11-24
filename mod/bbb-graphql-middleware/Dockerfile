ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src / /src/
RUN cd /src/ && CGO_ENABLED=0 go build -o bbb-graphql-middleware cmd/bbb-graphql-middleware/main.go

# ------------------------------
FROM alpine
COPY --from=builder /src/bbb-graphql-middleware /app/bbb-graphql-middleware
COPY --from=builder /src/config/config.yml /usr/share/bbb-graphql-middleware/config.yml
COPY config.yml /etc/bigbluebutton/bbb-graphql-middleware.yml
CMD [ "/app/bbb-graphql-middleware" ]