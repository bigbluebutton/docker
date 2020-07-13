# BigBlueButton Docker

## Features
- Easy installation
- Greenlight included
- TURN server included
- Fully automated HTTPS certificates
- Runs on almost any major linux distributon (Debian, Ubuntu, CentOS,...)
- Full IPv6 support

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
6. Run setup:
   ```bash
   $ ./scripts/setup
   ```
7. Start containers:
    ```bash
    $ ./scripts/compose up -d
    ```
8. If you use greenlight, you can create an admin account with:
    ```bash
    $ ./scripts/compose exec greenlight bundle exec rake admin:create
    ```





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

```bash
cd bbb-docker

# if you use greenlight:
# create a database backup
docker exec -t docker_postgres_1 pg_dumpall -c -U postgres > /root/greenlight_`date +%d-%m-%Y"_"%H_%M_%S`.sql

# upgrade!
./scripts/upgrade

# restart updated services
./scripts/compose up -d
```

If you're on an old version, you might get following error: \
`no such file or directory: ./scripts/upgrade` \
A simple `$ git pull` resolves that, by fetching a newer version which includes the upgrade script.

## Special thanks to
- @dkrenn, whos dockerized version (bigbluebutton#8858)(https://github.com/bigbluebutton/bigbluebutton/pull/8858) helped me a lot in understand and some configs.
