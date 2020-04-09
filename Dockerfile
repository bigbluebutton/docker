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
                       tidy libreoffice sudo netcat-openbsd net-tools penjdk-8-jre perl build-essential  \
                       ruby rake unzip xmlstarlet rsync tomcat7 yq equivs


# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/xenial-220 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list' 

RUN  sh -c 'wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -' \
  && sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list' 

# nodejs
RUN sh -c "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -"


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
    && dpkg -i /*.deb \
    && rm /*.deb

# -- create nginx service (in order to enable it - to avoid the "nginx.service is not active" error)
RUN rm -f /etc/systemd/system/nginx.service
COPY dummy/dummy.service /etc/systemd/system/nginx.service
COPY dummy/dummy.service /etc/systemd/system/redis.service
COPY dummy/dummy.service /etc/systemd/system/redis-server.service

RUN apt-get install -y nodejs

# bbb-html5 installer expects this file
RUN mkdir /usr/share/etherpad-lite && sh -c 'echo invalid > /usr/share/etherpad-lite/APIKEY.txt'


RUN touch /etc/init.d/nginx && chmod +x /etc/init.d/nginx
RUN apt-get install -y bbb-web bbb-record-core bbb-playback-presentation bbb-freeswitch-core \
                    bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka bbb-apps bbb-apps-sip \
                    bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast

RUN mkdir -p /etc/nginx/sites-enabled
RUN apt-get install -y bbb-html5 bbb-config bbb-client bbb-webrtc-sfu
RUN apt-get install -y mongodb-org
RUN apt-get install -y bbb-demo


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

COPY mod/tomcat7 /etc/init.d/tomcat7
RUN chmod +x /etc/init.d/tomcat7

COPY setup.sh /opt/setup.sh

ENTRYPOINT ["/bin/systemd", "--system", "--unit=multi-user.target"]
CMD []

