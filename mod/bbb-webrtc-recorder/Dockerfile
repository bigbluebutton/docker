# Build stage
FROM golang:1.19 as builder

ARG APP_VERSION=devel
ARG GOMOD=github.com/bigbluebutton/bbb-webrtc-recorder

WORKDIR /app

COPY --from=src go.* ./

RUN go mod tidy

COPY --from=src . ./

RUN go build -o ./build/bbb-webrtc-recorder \
      -buildvcs=false \
      -ldflags="-X '${GOMOD}/internal.AppVersion=${APP_VERSION}'" \
      ./cmd/bbb-webrtc-recorder

RUN mv /app/build/bbb-webrtc-recorder /usr/bin/bbb-webrtc-recorder

RUN rm -rf /app

# Running stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y gosu

# Copy the binary to the production image from the builder stage.
COPY --from=builder /usr/bin/bbb-webrtc-recorder /usr/bin/bbb-webrtc-recorder

# use same UID as in the recordings container
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

CMD ["/bin/sh", "-c", "chown -R bigbluebutton:bigbluebutton /var/lib/bbb-webrtc-recorder && gosu bigbluebutton /usr/bin/bbb-webrtc-recorder"]