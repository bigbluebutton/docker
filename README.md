# BigBlueButton Docker

## Please note
- Not well tested, can be still really buggy. Don't use for production! 

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
7. Adjust the values in `.env`
   - **Important:** don't forget to change `ETHERPAD_API_KEY`, `SHARED_SECRET` and `RAILS_SECRET` to any random values! For example generated with `pwgen 40 3`
   - `DOMAIN` and `EXTERNAL_IP` are also required. For example, use `dig +short <DOMAIN>` to get your external ip address. 
8. Start container. either...
    - **Most common setup**: BigBlueButton with automatic HTTPS certificate retrieval and Greenlight
        ```bash
        $ docker-compose \
            -f docker-compose.yml \
            -f docker-compose.https.yml \
            -f docker-compose.greenlight.yml \
            up --detach
        ```
    - **Individual parts**:
        - BigBlueButton `$ docker-compose up -d`
        - HTTPS reverse proxy
            - `$ docker-compose -f docker-compose.https.yml up -d`
        - API demos
            - `$ docker-compose -f docker-compose.demo.yml up -d`
            - Access https://bbb.example.com/demo/
        - Greenlight
            - `$ docker-compose -f docker-compose.greenlight.yml up -d`
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


## Upgrading

### Upgrade BigBlueButton
```bash
cd bbb-docker

# pull repo changes
git pull 

# update bbb-webrtc-sfu
git submodule update --remote 

# rebuild images
docker-compose build --pull --no-cache 

# recreate updated services
docker-compose up -d
```

### Upgrade Greenlight
**Important:** especially with a version before 2020-05-17 create a database backup first, otherwise the data will not be persistent between container recreations.
```bash
cd bbb-docker

# create a database backup
docker exec -t docker_postgres_1 pg_dumpall -c -U postgres > /root/greenlight_`date +%d-%m-%Y"_"%H_%M_%S`.sql

# pull repo changes
git pull 

# pull image updates
docker-compose -f docker-compose.greenlight.yml pull

# recreate & restart services if necessary
docker-compose -f docker-compose.greenlight.yml up -d
```

### Upgrade HTTPS Proxy
[to be written]

## Special thanks to
- @dkrenn, whos dockerized version (bigbluebutton#8858)(https://github.com/bigbluebutton/bigbluebutton/pull/8858) helped me a lot in understand and some configs.

## Open Tasks
- add support for recording
- add coturn support
- further separate bbb-core into individual container
- enable IPv6 support
- fix captions (they don't appear, `readOnlyPadId` is missing)
- switch to `node:12-buster-slim` for `html5`
- switch to `node:12-buster-slim` for `webrtc-sfu` 
- drop root privileges in `webrtc-sfu`
- drop root privileges in `kurento`
