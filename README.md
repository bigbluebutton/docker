<img width="1012" alt="bbb-docker-banner" src="https://user-images.githubusercontent.com/1273169/141153216-0386cd4e-0aaf-473a-8f42-a048e52ed0d7.png">


# 📦 BigBlueButton 3.0 Docker

Version: 3.0.4 | [Changelog](CHANGELOG.md) | [Issues](https://github.com/bigbluebutton/docker/issues) | [Upgrading](docs/upgrading.md) | [Development](docs/development.md)

## Features
- Easy installation
- Greenlight included
- TURN server included
- Fully automated HTTPS certificates
- Full IPv6 support
- Runs on any major linux distributon (Debian, Ubuntu, CentOS,...)

## currently missing / broken
- NAT support
- bbb-transcription-controller
- livekit

## Requirements
- 4GB of RAM
- Linux (it will not work under Windows/WSL)
- Root access (bbb-docker uses host networking, so it won't work with Kubernetes, any "CaaS"-Service, etc.)
- Public IPv4 (expect issues with a firewall / NAT)
- firewall allows internal networking (e.g. for ufw: `ufw allow 10.7.7.0/24`)
- git installed

## Install production server
1. Ensure the requirements above are fulfilled (it really doesn't work without them)
2. Install docker-ce & docker-compose-plugin
    1. follow instructions
        * Debian: https://docs.docker.com/engine/install/debian/
        * CentOS: https://docs.docker.com/engine/install/centos/
        * Fedora: https://docs.docker.com/engine/install/fedora/
        * Ubuntu: https://docs.docker.com/engine/install/ubuntu/
    2. Ensure docker works with `$ docker run hello-world`
    3. Ensure you use a docker version ≥ 23.0 : `$ docker --version`
3. Clone this repository
   ```sh
   $ git clone https://github.com/bigbluebutton/docker.git bbb-docker
   $ cd bbb-docker

   # optional: use the more stable main branch (often much older)
   $ git checkout main 
   ```
4. Run setup:
   ```bash
   $ ./scripts/setup
   ```
5. (optional) Make additional configuration adjustments
   ```bash
   $ nano .env
   # always recreate the docker-compose.yml file after making any changes
   $ ./scripts/generate-compose
   ```
6. Start containers:
    ```bash
    $ docker compose up -d --no-build
    ```
7. If you use greenlight, you can create an admin account with:
    ```bash
    $ docker compose exec greenlight bundle exec rake admin:create
    ```

## Development setup
1. Clone this repository
   ```sh
   $  git clone --recurse-submodules https://github.com/bigbluebutton/docker.git bbb-dev
   ```
2. Start dev server
   ```sh
   $ cd bbb-dev
   $ ./scripts/dev
   ```
3. Use API Mate with the link presented in the console to create & join a conference


## Further How-To's
<!-- - [Running behind NAT](docs/behind-nat.md) -->
- [Integration into an existing web server](docs/existing-web-server.md)

