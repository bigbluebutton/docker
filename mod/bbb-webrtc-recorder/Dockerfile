# Build stage
FROM golang:1.21 as builder

ARG APP_VERSION=devel
ARG GOMOD=github.com/bigbluebutton/bbb-webrtc-recorder

WORKDIR /app

COPY --from=src go.* ./

RUN go mod tidy

COPY --from=src . ./

RUN APP_VERSION=$(cat ./VERSION | sed 's/ /-/g') \
      go build -o ./build/bbb-webrtc-recorder \
      -ldflags="-X '$GOMOD/internal.AppVersion=v${APP_VERSION1}'" \
      ./cmd/bbb-webrtc-recorder


RUN mv /app/build/bbb-webrtc-recorder /usr/bin/bbb-webrtc-recorder

# Running stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y gosu

# use same UID as in the recordings container
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

# config
ENV BBBRECORDER_PUBSUB_ADAPTERS_REDIS_ADDRESS=redis:6379
ENV BBBRECORDER_PUBSUB_ADAPTERS_REDIS_NETWORK=tcp
ENV BBBRECORDER_DEBUG=true

# Copy the binary to the production image from the builder stage.
COPY --from=builder /usr/bin/bbb-webrtc-recorder /usr/bin/bbb-webrtc-recorder
COPY --from=builder /app/config/bbb-webrtc-recorder.yml /etc/bbb-webrtc-recorder/bbb-webrtc-recorder.yml

CMD ["/bin/sh", "-c", "chown -R bigbluebutton:bigbluebutton /var/lib/bbb-webrtc-recorder && gosu bigbluebutton /usr/bin/bbb-webrtc-recorder"]