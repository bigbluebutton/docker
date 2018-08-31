# Overview

Note: This branch contains work in progress for incorporating the HTML5 client into the Docker image.

To run BigBlueButton in Docker, run the command

~~~
docker run -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp b2 -h <HOST_IP>
~~~

Make sure you provide the host IP at the end of the command. This will take some time to pull the image from Docker hub.

For details see the [setup instructions](http://docs.bigbluebutton.org/labs/docker.html).

Once running, you can navigate to `http://<YOUR_HOST_IP>` to access your BigBlueButton server.

## Future Plans

Our goal was to allow developers to run BigBlueButton server with a single command.  This Docker image is not meant for production use, but rather for testing and trying out BigBlueButton.

Still, it good step towards separating BigBlueButton into individual components for running under docker-compose or kubernetes.
