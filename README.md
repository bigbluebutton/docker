# BigBlueButton Docker

![Travis CI](https://travis-ci.org/bigbluebutton/docker.svg?branch=master)
![Docker Pulls](https://img.shields.io/docker/pulls/bigbluebutton/bigbluebutton.svg)

(Note: These scripts are work in progress and not yet updated for BigBlueButton 2.2)

These are scripts to build a Docker that runs BigBlueButton with both the Flash and HTML5 client.  To build the Docker container, run the command

~~~
docker build -t bigbluebutton .
~~~

Here we called the BigBlueButton container `bigbluebutton`. To run BigBlueButton in Docker, run the command

~~~
docker run --rm -p 80:80/tcp -p 1935:1935 -p 3478:3478 -p 3478:3478/udp bigbluebutton -h <HOST_IP>
~~~

Make sure you provide the host IP of the server on which you run the docker command. Once running, you can navigate to `http://<HOST_IP>` to access your BigBlueButton server.

## Future Plans

Our goal was to allow developers to run BigBlueButton server with a single command.  This Docker image is not meant for production use, but rather for testing and trying out BigBlueButton.

Still, it good step towards separating BigBlueButton into individual components for running under docker-compose or kubernetes.
