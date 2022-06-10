
FROM ruby:2.7-slim-buster

# install apt dependencies
RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    rsync \
    build-essential \
    libsystemd-dev \
    python3 \
    python3-attr \
    python3-cairo \
    python3-gi \
    python3-gi-cairo \
    python3-lxml \
    python3-icu \
    python3-pyinotify \
    gir1.2-pangocairo-1.0 \
    ffmpeg \
    poppler-utils \
    imagemagick \
    supervisor \
    locales \
    locales-all
# TODO: missing packages

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# compile and install mkclean
RUN cd /tmp \
    && wget https://netcologne.dl.sourceforge.net/project/matroska/mkclean/mkclean-0.8.10.tar.bz2 \
    && tar -xf /tmp/mkclean-0.8.10.tar.bz2 \
    && cd /tmp/mkclean-0.8.10 \
    && sed -i 's/\r//g' ./mkclean/configure.compiled \
    && ./mkclean/configure.compiled \
    && make -C mkclean \
    && cp ./release/gcc_linux_x64/mkclean /usr/bin/mkclean \
    && rm -r /tmp/mkclean-*

# add dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget -q https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# add yq for bbb-record
RUN  wget -q https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

RUN mkdir -p \
    /usr/local/bigbluebutton \
    /usr/local/bigbluebutton/core \
    /etc/bigbluebutton

ARG TAG_RECORDINGS

# add bbb-record-core (lib, scripts and Gemfile)
RUN cd /usr/local/bigbluebutton/core \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_RECORDINGS/record-and-playback/core/lib \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_RECORDINGS/record-and-playback/core/scripts \
    && rm -rf /usr/local/bigbluebutton/core/*/.svn \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG_RECORDINGS/record-and-playback/core/Gemfile.lock \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG_RECORDINGS/record-and-playback/core/Gemfile \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG_RECORDINGS/record-and-playback/core/Rakefile

# add bbb-playback-presentation scripts
RUN cd /tmp \
    && svn checkout https://github.com/bigbluebutton/bigbluebutton/tags/$TAG_RECORDINGS/record-and-playback/presentation/scripts \
    && rsync -av /tmp/scripts/ /usr/local/bigbluebutton/core/scripts/ \
    && rm -rf /tmp/scripts

# install ruby dependencies
RUN cd /usr/local/bigbluebutton/core \
    && gem install builder \
    && gem install bundler --no-document \
    && /usr/local/bin/bundle

# log to file instead of journald
RUN sed -i 's|Journald::Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/lib/recordandplayback.rb && \
    sed -i 's|Journald::Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/rap-caption-inbox.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/rap-process-worker.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/archive/archive.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/publish/presentation.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/utils/captions.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/process/presentation.rb

# add bbb-record with some adjustments so bbb-record works in this environment
RUN cd /usr/bin \
    && wget https://raw.githubusercontent.com/bigbluebutton/bigbluebutton/$TAG_RECORDINGS/bigbluebutton-config/bin/bbb-record \
    && chmod +x /usr/bin/bbb-record \
    && sed -i 's/^BBB_WEB.*/BBB_WEB=""/' /usr/bin/bbb-record \
    && sed -i 's/systemctl.*//' /usr/bin/bbb-record \
    && echo "BIGBLUEBUTTON_RELEASE=$TAG_RECORDINGS" > /etc/bigbluebutton/bigbluebutton-release

# create user
# the ID should match the one creating the files in `core`
RUN groupadd -g 998 bigbluebutton && useradd -m -u 998 -g bigbluebutton bigbluebutton

# change owner
# https://github.com/alangecker/bigbluebutton-docker/issues/63
RUN chown -R 998:998 /usr/local/bigbluebutton

COPY bbb-web.properties /etc/bigbluebutton/bbb-web.properties.tmpl
COPY bigbluebutton.yml /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml.tmpl
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
