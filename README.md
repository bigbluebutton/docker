# BigBlueButton Docker

## Please note
- Not well tested, can be still really buggy. Don't use for production! 
- Serves BBB on HTTP Port 8080. It is your responsibility to add a HTTPS reverse proxy

## Install
1. Install docker-ce & docker-compose
    1. follow instructions
        * Debian: https://docs.docker.com/engine/install/debian/
        * CentOS: https://docs.docker.com/engine/install/centos/
        * Fedora: https://docs.docker.com/engine/install/fedora/
        * Ubuntu: https://docs.docker.com/engine/install/ubuntu/
    2. Ensure docker works with `$ docker run hello-world`
    3. Install docker-compose: https://docs.docker.com/compose/install/
    4. Ensure docker-compose works: `$ docker-compose --version`
5. Clone this repository
   ```sh
   $ git clone --recurse-submodules https://github.com/alangecker/bigbluebutton-docker.git bbb-docker
   $ cd bbb-docker
   ```
6. Create `.env` with `$ cp sample.env .env`
7. Adjust the values in `.env` (don't forget to change the `ETHERPAD_API_KEY`, `SHARED_SECRET` and `RAILS_SECRET`!)
8. Start BigBlueButton `$ docker-compose -d up`
9. Optionally...
    - Start api demos
        - `$ docker-compose -d -f docker-compose.demo.yml up`
        - Access https://bbb.example.com/demo/
    - Start greenlight
        - `$ docker-compose -d -f docker-compose.greenlight.yml up`
        - Create an administrator account \
        `$ docker exec greenlight-v2 bundle exec rake admin:create`
        - Access https://bbb.example.com/b

## Note if you use a Firewall / NAT
Kurento binds somehow always to the external IP instead of the local one or `0.0.0.0`. For that reason you need to add your external IP to your interface.

##### Temporary  way (until next reboot)
```
$ ip addr add 144.76.97.34/32 dev ens3
```

##### Permanent way
Specific to your linux distribution. Use a search engine of your choice. ;)

### Ports
Also don't forget to forward all necassary ports listed in http://docs.bigbluebutton.org/2.2/configure-firewall.html

## Open Tasks
- add optional https support via lets encrypt
- add support for recording
- further separate bbb-core into individual container

