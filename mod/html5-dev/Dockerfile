ARG BBB_BUILD_TAG
FROM bigbluebutton/bbb-build:$BBB_BUILD_TAG


# use /tmp as home dir as writeable directory for whatever UID we get
ENV HOME /tmp

# allow all user to access .nvm in root
RUN chmod 755 /root

WORKDIR /app
COPY /entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
