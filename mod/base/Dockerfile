FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# just to speed up development, TODO: remove
COPY sources.list /etc/apt/sources.list 

RUN apt-get update && apt-get install -y software-properties-common language-pack-en 
RUN update-locale LANG=en_US.UTF-8
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:rmescandon/yq
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install grub-pc update-notifier-common
RUN apt-get update \
    && apt-get install -y systemd


# -- Install Dependencies
RUN apt-get install -y wget apt-transport-https curl mlocate strace iputils-ping telnet tcpdump vim htop \
                       tidy libreoffice sudo netcat-openbsd net-tools openjdk-8-jre perl build-essential  \
                       ruby rake unzip xmlstarlet rsync tomcat7 yq equivs


# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/xenial-220 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list' 

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && equivs-control nginx.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/nginx/g' nginx.control \
    && equivs-build nginx.control \
    && equivs-control bbb-etherpad.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/bbb-etherpad/g' bbb-etherpad.control \
    && equivs-build bbb-etherpad.control \
    && equivs-control kurento-media-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/kurento-media-server/g' kurento-media-server.control \
    && equivs-build kurento-media-server.control \
    && equivs-control bbb-webrtc-sfu.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/bbb-webrtc-sfu/g' bbb-webrtc-sfu.control \
    && equivs-build bbb-webrtc-sfu.control \
    && dpkg -i /*.deb \
    && rm /*.deb

# -- create nginx service (in order to enable it - to avoid the "nginx.service is not active" error)
RUN rm -f /etc/systemd/system/nginx.service
COPY dummy.service /etc/systemd/system/nginx.service
COPY dummy.service /etc/systemd/system/redis.service
COPY dummy.service /etc/systemd/system/redis-server.service
COPY dummy.service /etc/systemd/system/kurento-media-server.service
COPY dummy.service /etc/systemd/system/bbb-webrtc-sfu.service

RUN touch /etc/init.d/nginx && chmod +x /etc/init.d/nginx
RUN apt-get update && apt-get install -y bbb-web bbb-record-core bbb-playback-presentation bbb-freeswitch-core \
                    bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka bbb-apps bbb-apps-sip \
                    bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast

RUN mkdir -p /etc/nginx/sites-enabled /var/kurento

RUN apt-get install -y bbb-config

# -- Disable unneeded services
RUN systemctl disable systemd-journal-flush
RUN systemctl disable systemd-update-utmp.service

# -- Finish startup 
#    Add a number there to force update of files on build
RUN echo "Finishing ... @13"

RUN useradd bbb --uid 1000 -s /bin/bash
RUN mkdir /home/bbb
RUN chown bbb /home/bbb
RUN sh -c 'echo "bbb ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/bbb'
RUN sh -c 'echo "bbb:bbb" | chpasswd'

# disable IPv6 support
RUN rm -rf /opt/freeswitch/conf/sip_profiles/*-ipv6*

# disable all services
RUN find /etc/systemd/ | grep wants | xargs -r -n 1 basename | grep service | grep -v networking | grep -v tty   | xargs -r -n 1 -I __ systemctl disable __
RUN systemctl disable tomcat7
RUN systemctl enable red5 freeswitch bbb-apps-akka bbb-transcode-akka bbb-fsesl-akka bbb-rap-caption-inbox bbb-web

COPY tomcat7 /etc/init.d/tomcat7
RUN chmod +x /etc/init.d/tomcat7

COPY setup.sh /opt/setup.sh

ENTRYPOINT ["/bin/systemd", "--system", "--unit=multi-user.target"]
CMD []

