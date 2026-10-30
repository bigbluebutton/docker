# Build stage
FROM golang:1.27.3 AS builder

RUN apt update && apt install -y pkg-config libopus-dev libopusfile-dev libsoxr-dev

ENV LIVKIT_SIP_VERSION=v1.21.0

RUN mkdir /tmp/livekit-sip && curl "https://github.com/livekit/sip/archive/${LIVKIT_SIP_VERSION}.tar.gz" -Lo - | tar -xzf - -C /tmp/livekit-sip && mv /tmp/livekit-sip/sip-* /src

COPY --from=src-build *_sip.patch /patches/

WORKDIR /src
RUN for patch in /patches/*_sip.patch; do echo "Applying patch: $patch" && git apply "$patch"; done


RUN CGO_ENABLED=1 GOOS=linux GOARCH="amd64" GO111MODULE=on go build -a -o livekit-sip ./cmd/livekit-sip


# Running stage
FROM debian:trixie-slim

RUN apt update && apt install -y libopus0 libopusfile0 libsoxr0

# use same UID as in the recordings container
RUN groupadd -g 1001 livekit-sip && useradd -m -u 1001 -g livekit-sip livekit-sip

# Copy the binary to the production image from the builder stage.
COPY --from=builder /src/livekit-sip /usr/local/bin/livekit-sip
COPY livekit-sip.yaml /etc/livekit-sip.yaml

USER livekit-sip
CMD ["/usr/local/bin/livekit-sip", "--config", "/etc/livekit-sip.yaml"]