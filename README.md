# 📦 BigBlueButton 2.3 Docker

Version: 2.3.0 | [Changelog](CHANGELOG.md) | [Issues](https://github.com/bigbluebutton/docker/issues)

## Features
- Easy installation
- Greenlight included
- Fully automated HTTPS certificates
- Full IPv6 support
- Runs on any major linux distributon (Debian, Ubuntu, CentOS,...)
- BBB development support: Custom config of branch/tag and repo (e.g. also a fork)

## What is not implemented yet
- bbb-lti

## Install
1. Install docker-ce & docker-compose
    1. follow instructions
        * Debian: https://docs.docker.com/engine/install/debian/
        * CentOS: https://docs.docker.com/engine/install/centos/
        * Fedora: https://docs.docker.com/engine/install/fedora/
        * Ubuntu: https://docs.docker.com/engine/install/ubuntu/
    2. Ensure docker works with `$ docker run hello-world`
    3. Install docker-compose: https://docs.docker.com/compose/install/
    4. Ensure docker-compose works and that you use a version ≥ 1.28 : `$ docker-compose --version`
2. Clone this repository
   ```sh
   $ git clone -b main --recurse-submodules https://github.com/bigbluebutton/docker.git bbb-docker
   $ cd bbb-docker
   ```
3. Run setup:
   ```bash
   $ ./scripts/setup
   ```
4. (optional) Make additional configuration adjustments
   ```bash
   $ nano .env
   # always recreate the docker-compose.yml file after making any changes
   $ ./scripts/generate-compose
   ```
5. Start containers:
    ```bash
    $ docker-compose up -d
    ```
6. If you use greenlight, you can create an admin account with:
    ```bash
    $ docker-compose exec greenlight bundle exec rake admin:create
    ```
7. If you want to build a different tag/branch or use another repo or fork:
   Add the following to your .env
   ```
   BBB_REPO_URL=https://github.com/longliveenduro/bigbluebutton.git
   BBB_BRANCH_OR_TAG=develop
   # or
   # BBB_BRANCH_OR_TAG=tags/v2.3.1
   ```

## Further How-To's
- [Upgrading](docs/upgrading.md)
- [Running behind NAT](docs/behind-nat.md)
- [BBB-Docker Development](docs/development.md)
- [Integration into an existing web server](docs/existing-web-server.md)

