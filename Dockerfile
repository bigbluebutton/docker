FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# just to speed up development, TODO: remove
COPY sources.list /etc/apt/sources.list 

RUN apt-get update && apt-get install -y netcat

# -- Install utils
RUN apt-get update && apt-get install -y wget apt-transport-https curl

RUN apt-get install -y language-pack-en
RUN update-locale LANG=en_US.UTF-8

# -- Install system utils
RUN apt-get update 
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y wget software-properties-common

# -- Install yq 
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:rmescandon/yq
RUN apt update
RUN LC_CTYPE=C.UTF-8 apt install yq -y

# -- Setup tomcat7 to run under docker
RUN apt-get install -y \
  haveged    \
  net-tools  \
  supervisor \
  sudo       \
  tomcat7

RUN sed -i 's|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g'  /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

# -- Modify systemd to be able to run inside container
RUN apt-get update \
    && apt-get install -y systemd

# -- Install Dependencies
RUN apt-get install -y mlocate strace iputils-ping telnet tcpdump vim htop

RUN apt-get install -y curl apt-transport-https software-properties-common tidy libreoffice openjdk-8-jre perl build-essential ruby redis-server rake unzip tomcat7 xmlstarlet rsync python3 

RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support

# nodejs
RUN sh -c "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -"


RUN sh -c 'echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections'

# bbb repo & packages
RUN sh -c 'wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/xenial-220 bigbluebutton-xenial main" > /etc/apt/sources.list.d/bigbluebutton.list' \
    && apt update \
    && apt install -y bigbluebutton netcat-openbsd bbb-web bbb-client bbb-playback-presentation bbb-freeswitch-core bbb-webrtc-sfu bbb-fsesl-akka bbb-apps-akka bbb-transcode-akka openssl bbb-apps bbb-apps-sip bbb-apps-video bbb-apps-screenshare bbb-apps-video-broadcast


RUN  sh -c 'wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -' \
  && sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list' \
  && apt-get update \
  && apt-get install -y haveged mongodb-org

RUN apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install grub-pc update-notifier-common


RUN apt-get install -y bbb-etherpad bbb-html5 bbb-demo

# -- Install nginx (in order to enable it - to avoid the "nginx.service is not active" error)
RUN apt-get install -y nginx
RUN systemctl enable nginx

# -- Disable unneeded services
RUN systemctl disable systemd-journal-flush
RUN systemctl disable systemd-update-utmp.service

# -- Finish startup 
#    Add a number there to force update of files on build
RUN echo "Finishing ... @13"
RUN mkdir /opt/docker-bbb/

RUN useradd bbb --uid 1000 -s /bin/bash
RUN mkdir /home/bbb
RUN chown bbb /home/bbb
RUN sh -c 'echo "bbb ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/bbb'
RUN sh -c 'echo "bbb:bbb" | chpasswd'

COPY mod/tomcat7 /etc/init.d/tomcat7
RUN chmod +x /etc/init.d/tomcat7

COPY setup.sh /opt/docker-bbb/setup.sh

ENTRYPOINT ["/bin/systemd", "--system", "--unit=multi-user.target"]
CMD []

