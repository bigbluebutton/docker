# BigBlueButton Docker

## Features
- Easy installation
- Greenlight included
- TURN server included
- Fully automated HTTPS certificates
- Runs on almost any major linux distributon (Debian, Ubuntu, CentOS,...)

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

## How to integrate into an existing Apache setup

Since the non-dockerized version of BigBlueButton has [many requirements](https://docs.bigbluebutton.org/2.2/install.html#minimum-server-requirements), such as a specific Ubuntu version (16.04) as well as ports 80/443 not being in use by other applications, and considering that [a "clean" server dedicated for BigBlueButton is recommended](https://docs.bigbluebutton.org/2.2/install.html#before-you-install), you may enjoy the benefits of this dockerized version in order to run BigBlueButton on a server that is not completely dedicated to this software, on which a Web Server may be already in use.

You could dedicate a virtual host to BigBlueButton, allowing external access to it through a reverse proxy. If your server is running Apache, the following steps are an example of how to set up a working configuration.

1. Install BigBlueButton Docker [as explained above](#install). While running the setup script, please choose `n` when you're asked the following question: `Should an automatic HTTPS Proxy be included? (y/n)`.
> **Note.** The automatic HTTPS Proxy is not needed if you are going to run BigBlueButton behind a reverse proxy; in that case, you should be able to enable SSL for the virtual host you are going to dedicate to BigBlueButton, using Apache features. Please notice that it will not be possible to install and use the integrated TURN server, since it requires the automatic HTTPS Proxy to be installed; therefore, if a TURN server is required, you should install and configure it by yourself. You can set BigBlueButton to use a TURN server by uncommenting and adjusting `TURN_SERVER` and `TURN_SECRET` in the `.env` file, which is created after completion of the setup script.
2. Now all the required Docker containers should be running. BigBlueButton listens to port 8080. On Apache, create a virtual host by which BigBlueButton will be publicly accessible (in this case, let's assume the following server name for the virtual host: `bbb.example.com`). Enable SSL for the new _https_ virtual host. Make sure that the SSL certificate you will be using is signed by a CA (Certificate Authority). You could generate an SSL certificate for free using Let's Encrypt. It is suggested to add some directives to the _http_ virtual host `bbb.example.com` to redirect all requests to the _https_ one, for example:
```
RewriteEngine On
RewriteRule ^/(.*) https://%{HTTP_HOST}/$1 [R]
```
3. Make sure that the following Apache modules are in use: `proxy`, `rewrite`, `proxy_http`, `proxy_wstunnel`. On _apache2_, the following command activates these modules,  whenever they are not already enabled: `sudo a2enmod proxy rewrite proxy_http proxy_wstunnel`.
4. Add the following directives to the _https_ virtual host `bbb.example.com`:
```
ProxyPreserveHost On

RewriteEngine On
RewriteCond %{HTTP:UPGRADE} ^WebSocket$ [NC,OR]
RewriteCond %{HTTP:CONNECTION} ^Upgrade$ [NC]
RewriteRule .* ws://127.0.0.1:8080%{REQUEST_URI} [P,QSA,L]

<Location />
	Require all granted
	ProxyPass http://127.0.0.1:8080/
	ProxyPassReverse http://127.0.0.1:8080/
</Location>
```
5. After restarting Apache, BigBlueButton should be publicly accessible on `https://bbb.example.com/`. If you chose to install Greenlight, then the previous URL should allow you to open its home page. The APIs will be accessible through `https://bbb.example.com/bigbluebutton/`.

## Special thanks to
- @dkrenn, whos dockerized version (bigbluebutton#8858)(https://github.com/bigbluebutton/bigbluebutton/pull/8858) helped me a lot in understand and some configs.
