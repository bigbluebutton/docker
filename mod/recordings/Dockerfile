
FROM ruby:2.7-slim-bullseye

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
    python3-sortedcollections \
    python3-packaging \
    gir1.2-pangocairo-1.0 \
    gir1.2-poppler-0.18 \
    gir1.2-gtk-3.0 \
    gir1.2-gdkpixbuf-2.0 \
    fonts-croscore \
    ffmpeg \
    poppler-utils \
    imagemagick \
    supervisor \
    unzip \
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
    /etc/bigbluebutton \
    /etc/bigbluebutton/recording

# dependency for bbb-presentation-video
RUN wget -q -O /tmp/python3-perfect-freehand.deb https://github.com/bigbluebutton/perfect-freehand-python/releases/download/1.2.0/python3-perfect-freehand_1.2.0_all.deb && \
    dpkg -i /tmp/python3-perfect-freehand.deb && \
    rm /tmp/python3-perfect-freehand.deb

ARG TAG_RECORDINGS

COPY --from=record-core / /usr/local/bigbluebutton/core

# add bbb-playback-presentation scripts
COPY --from=presentation /scripts /usr/local/bigbluebutton/core/scripts/ 

# install ruby dependencies
RUN cd /usr/local/bigbluebutton/core \
    && gem install builder \
    && gem install bundler --no-document \
    && bundle config set --local deployment true \
    && bundle install \
    && bundle clean \
    && rm -r vendor/bundle/ruby/*/cache \
    && find vendor/bundle -name '*.o' -delete

# log to file instead of journald
RUN sed -i 's|Journald::Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/lib/recordandplayback.rb && \
    sed -i 's|Journald::Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/rap-caption-inbox.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/rap-process-worker.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/archive/archive.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/publish/presentation.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/utils/captions.rb && \
    sed -i 's|Logger\.new.*|Logger.new("/var/log/bigbluebutton/recording.log")|g' /usr/local/bigbluebutton/core/scripts/process/presentation.rb

# add bbb-record with some adjustments so bbb-record works in this environment
COPY --from=bbb-conf /bin/bbb-record /usr/bin/bbb-record
RUN cd /usr/bin \
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

ARG TAG_BBB_PRESENTATION_VIDEO
RUN cd /tmp/ && \
    wget -q -O bbb-presentation-video.zip "https://github.com/bigbluebutton/bbb-presentation-video/releases/download/${TAG_BBB_PRESENTATION_VIDEO}/ubuntu-20.04.zip" && \
    unzip -o bbb-presentation-video.zip -d bbb-presentation-video && \
    dpkg -i bbb-presentation-video/bbb-presentation-video*.deb && \
    rm -rf /tmp/*

COPY bbb-web.properties /etc/bigbluebutton/bbb-web.properties.tmpl
COPY recording.yml /etc/bigbluebutton/recording/recording.yml.tmpl
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
