FROM tomcat:7-jdk8-openjdk

ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update &&  apt-get install -y wget binutils

# download & install bbb-demo package manually
RUN PACKAGE_PATH=$(curl -s https://ubuntu.bigbluebutton.org/xenial-220/dists/bigbluebutton-xenial/main/binary-amd64/Packages | grep -E 'Filename.*bbb-demo' | awk '{print $2}') \
    && wget https://ubuntu.bigbluebutton.org/xenial-220/$PACKAGE_PATH \
    && ar x bbb-demo_*.deb \
    && tar x -f data.tar.gz ./var/tmp/demo.war \
    && unzip ./var/tmp/demo.war -d /usr/local/tomcat/webapps/demo

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh