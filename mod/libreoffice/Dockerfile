FROM woahbase/alpine-libreoffice

USER root

RUN apk add su-exec
# should use the same user ID as in `core` to avoid file permission issues
RUN addgroup -g 998 bigbluebutton && adduser -D -u 998 -G bigbluebutton bigbluebutton
COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT /entrypoint.sh
