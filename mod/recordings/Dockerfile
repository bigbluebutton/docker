
FROM ruby:2.4-slim-buster

# install apt dependencies
RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    rsync \
    build-essential \
    libsystemd-dev \
    python3 \
    python3-pyinotify \
    python3-lxml \
    python3-icu \
    ffmpeg \
    poppler-utils \
    imagemagick

# compile and install mkclean
RUN cd /tmp \
    && wget https://netcologne.dl.sourceforge.net/project/matroska/mkclean/mkclean-0.8.10.tar.bz2 \
    && tar -xf /tmp/mkclean-0.8.10.tar.bz2 \
    && cd /tmp/mkclean-0.8.10 \
    && sed -i 's/\r//g' ./mkclean/configure.compiled \
    && ./mkclean/configure.compiled \
    && make -C mkclean \
    && cp ./release/gcc_linux_x64/mkclean /usr/bin/mkclean \
    && rm -r /tmp/mkclean-0.8.10

# add dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir -p \
    /usr/local/bigbluebutton \
    /usr/local/bigbluebutton/core \
    /etc/bigbluebutton \
    /var/log/bigbluebutton \
    /var/log/bigbluebutton/presentation

ENV TAG v2.2.26

# add bbb-record-core (lib, scripts and Gemfile)
RUN cd /usr/local/bigbluebutton/core \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/record-and-playback/core/lib \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/record-and-playback/core/scripts \
    && rm -rf /usr/local/bigbluebutton/core/*/.svn \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG/record-and-playback/core/Gemfile.lock \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG/record-and-playback/core/Gemfile


# add bbb-playback-presentation scripts
RUN cd /tmp \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG/record-and-playback/presentation/scripts \
    && rsync -av /tmp/scripts/ /usr/local/bigbluebutton/core/scripts/ \
    && rm -rf /tmp/scripts

# install ruby dependencies
RUN cd /usr/local/bigbluebutton/core \
    && gem install builder \
    && gem install bundler \
    && /usr/local/bin/bundle

# add bbb-record with some adjustments so bbb-record works in this environment
RUN cd /usr/bin \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG/bigbluebutton-config/bin/bbb-record \
    && chmod +x /usr/bin/bbb-record \
    && sed -i 's/^BBB_WEB.*/BBB_WEB=""/' /usr/bin/bbb-record \
    && sed -i 's/systemctl.*//' /usr/bin/bbb-record \
    && echo "BIGBLUEBUTTON_RELEASE=$TAG" > /etc/bigbluebutton/bigbluebutton-release \
    && touch /var/log/bigbluebutton/bbb-web.log

# create user
# the ID should matcht the one creating the files in `core`
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

COPY bigbluebutton.yml /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml.tmpl
ADD log-collector.py /log-collector.py
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT dockerize \
    -template /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml.tmpl:/usr/local/bigbluebutton/core/scripts/bigbluebutton.yml \
    /entrypoint.sh