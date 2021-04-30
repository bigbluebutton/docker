FROM eugenmayer/jodconverter:rest
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN sed -i 's/main/main contrib/' /etc/apt/sources.list && apt-get update
RUN apt-get update && apt -y install  --no-install-recommends \
    fonts-arkpandora \
    fonts-crosextra-carlito \
    fonts-crosextra-caladea \
    fonts-noto \
    fonts-noto-cjk \
    fonts-liberation \
    fontconfig \
    ttf-mscorefonts-installer