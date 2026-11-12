FROM golang:1.27.3-alpine3.24@sha256:f2c872bcee949b7be9c490efd02b48a8a2fbf947cdf533f1c58525ec9d8170fd AS builder

RUN apk add git
RUN git clone --branch v1.13.11 --depth=1 https://github.com/livekit/livekit.git /src
WORKDIR /src

# use psrpc version with following fix included:
# https://github.com/livekit/psrpc/pull/159
# https://github.com/bigbluebutton/bigbluebutton/commit/f1ed5ff4b6104a3436fef4155abd2dd0f8b57f29
RUN go get github.com/livekit/psrpc@9e02cd6b9513a6483d61ecae75621ba8c758b083

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o livekit-server ./cmd/server

FROM alpine:3.24.3@sha256:c6b073f8e9e58d881f6ffba6ebf3b9ebd60b9e7d6e8337018c0e68bb5c356873

COPY --from=builder /src/livekit-server /livekit-server

ENTRYPOINT ["/livekit-server"]


