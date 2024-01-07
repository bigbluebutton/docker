ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG AS builder

COPY --from=src / /src/
RUN cd /src/ && ./local-build.sh


# ------------------------------
FROM alpine
COPY --from=builder /src/bbb-graphql-middleware /app/bbb-graphql-middleware
CMD [ "/app/bbb-graphql-middleware" ]