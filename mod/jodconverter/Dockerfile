FROM ghcr.io/jodconverter/jodconverter-examples:rest
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN sed -i 's/main/main contrib/' /etc/apt/sources.list.d/debian.sources && apt-get update
RUN apt-get update && apt -y install  --no-install-recommends \
    fonts-arkpandora \
    fonts-crosextra-carlito \
    fonts-crosextra-caladea \
    fonts-noto \
    fonts-noto-cjk \
    fonts-liberation \
    fontconfig \
    ttf-mscorefonts-installer


# avoid "APPLICATION FAILED TO START. Config data location '/etc/app/' does not exist"
# https://github.com/bigbluebutton/docker/issues/178
CMD ["--spring.config.additional-location=optional:/etc/app/"]