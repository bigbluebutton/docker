FROM woahbase/alpine-libreoffice

USER root

RUN apk add --no-cache \
        su-exec \
        font-noto \
        font-noto-cjk

# should use the same user ID as in `core` to avoid file permission issues
RUN addgroup -g 998 bigbluebutton && adduser -D -u 998 -G bigbluebutton bigbluebutton
COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT /entrypoint.sh
