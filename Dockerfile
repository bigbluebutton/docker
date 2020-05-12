FROM ubuntu:16.04
MAINTAINER ffdixon@bigbluebutton.org

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y language-pack-en \
    && update-locale LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get -y dist-upgrade \
    && apt-get install -y curl wget apt-transport-https software-properties-common vim mlocate sudo

RUN echo "deb http://ubuntu.bigbluebutton.org/xenial-200 bigbluebutton-xenial main " | tee /etc/apt/sources.list.d/bigbluebutton.list\
    && wget http://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -\
    && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list\
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6\
    && add-apt-repository ppa:jonathonf/ffmpeg-4 -y\
    && add-apt-repository ppa:rmescandon/yq -y\
    && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -\
    && echo 'deb http://deb.nodesource.com/node_8.x xenial main' > /etc/apt/sources.list.d/nodesource.list\
    && echo 'deb-src http://deb.nodesource.com/node_8.x xenial main' >> /etc/apt/sources.list.d/nodesource.list\
    && apt-get update


# -- Setup tomcat7 to run under docker
RUN apt-get install -y \
  haveged    \
  net-tools  \
  supervisor \
  tomcat7

RUN sed -i 's|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g'  /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security
ADD mod/tomcat7 /etc/init.d/tomcat7
RUN chmod +x /etc/init.d/tomcat7

# -- Install BigBlueButton
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install -y rubygems && gem install bundler -v 1.16.1
RUN apt-get install -y bigbluebutton
RUN apt-get install -y bbb-demo 

# -- Install and configure mongodb (for HTML5 client)
RUN apt-get install -y mongodb-org\
    && echo 'replication.replSetName: rs0' >> /etc/mongod.conf && sed -i 's/127.0.0.1/127.0.1.1/' /etc/mongod.conf

# -- Install nodejs (for HTML5 client)
RUN apt-get install -y nodejs 

# -- Install HTML5 client
RUN apt-get install -y bbb-html5

RUN apt-get install -y coturn xmlstarlet

# -- Install supervisor to run all the BigBlueButton processes (replaces systemd)
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# -- Modify FreeSWITCH event_socket.conf.xml to listen to IPV4
ADD mod/event_socket.conf.xml /opt/freeswitch/etc/freeswitch/autoload_configs
ADD mod/external.xml          /opt/freeswitch/conf/sip_profiles/external.xml

# RUN apt-get install -y bbb-etherpad

# -- Finish startup
ADD setup.sh /root/setup.sh
ENTRYPOINT ["/root/setup.sh"]
CMD []
