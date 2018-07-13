# Overview

These are scripts to run BigBlueButton within Docker.

For detailed instructions on how to setup BigBlueButton in Docker, see the [setup instructions](http://docs.bigbluebutton.org/labs/docker.html).

To run BigBlueButton in Docker with a single command, run:

~~~
docker run -p 80:80/tcp -p 1935:1935/tcp -p 5066:5066/tcp -p 32730-32768:32730-32768/udp -p 2202:2202 --cap-add=NET_ADMIN --name bigbluebutton bigbluebutton/bigbluebutton -h <YOUR_HOST_IP>
~~~

Make sure you provide the host IP at the end of the command. This will take some time to pull the image from Docker hub.

Once running, you can navigate to `http://<YOUR_HOST_IP>` to access your BigBlueButton server.

## Keep in mind...

Our goal was to allow people to try a BigBlueButton server with a single command. This is not meant for production use, but rather for testing and trying out BigBlueButton.

We may work on a production-ready version that seperates the BigBlueButton components into containers using [docker-compose](https://github.com/docker/compose) in the future.
