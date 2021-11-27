# How to integrate into an existing Web server setup

Since the non-dockerized version of BigBlueButton has [many requirements](https://docs.bigbluebutton.org/2.2/install.html#minimum-server-requirements), such as a specific Ubuntu version (16.04) as well as ports 80/443 not being in use by other applications, and considering that [a "clean" server dedicated for BigBlueButton is recommended](https://docs.bigbluebutton.org/2.2/install.html#before-you-install), you may enjoy the benefits of this dockerized version in order to run BigBlueButton on a server that is not completely dedicated to this software, on which a Web server may be already in use.

You could dedicate a virtual host to BigBlueButton, allowing external access to it through a reverse proxy.

> **Note.** The automatic HTTPS Proxy is not needed if you are going to run BigBlueButton behind a reverse proxy; in that case, you should be able to enable SSL for the virtual host you are going to dedicate to BigBlueButton, using your Web server features. Please notice that it will not be possible to install and use the integrated TURN server, since it requires the automatic HTTPS Proxy to be installed; therefore, if a TURN server is required, you should install and configure it by yourself. You can set BigBlueButton to use a TURN server by uncommenting and adjusting `TURN_SERVER` and `TURN_SECRET` in the `.env` file, which is created after completion of the setup script.

## Installation
1. Install BigBlueButton Docker [as explained above](#install). While running the setup script, please choose `n` when you're asked the following question: `Should an automatic HTTPS Proxy be included? (y/n)`.
2. Now all the required Docker containers should be running. BigBlueButton listens to port 48087. Create a virtual host by which BigBlueButton will be publicly accessible (in this case, let's assume the following server name for the virtual host: `bbb.example.com`). Enable SSL for the new _https_ virtual host. Make sure that the SSL certificate you will be using is signed by a CA (Certificate Authority). You could generate an SSL certificate for free using Let's Encrypt. It is suggested to add some directives to the _http_ virtual host `bbb.example.com` to redirect all requests to the _https_ one.

At this point, choose one of the following sections according to which Web server you're running ([Apache](#integration-with-apache)).

Eventually, BigBlueButton should be publicly accessible on `https://bbb.example.com/`. If you chose to install Greenlight, then the previous URL should allow you to open its home page. The APIs will be accessible through `https://bbb.example.com/bigbluebutton/`.

## Integration with nginx
1. Add the following directives to the _https_ virtual host `bbb.example.com` 
```
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}
map $remote_addr $endpoint_addr {
    "~:"    [::1];
    default    127.0.0.1;
}

server {
  listen 443 ssl http2 default_server;
  listen [::]:443 ssl http2 default_server;
  server_name bbb.example.com;

  ssl_certificate /etc/letsencrypt/live/bbb.example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/bbb.example.com/privkey.pem;

  access_log  /var/log/nginx/bigbluebutton.access.log;
  error_log /var/log/nginx/bigbluebutton.error.log;

  location / {
    proxy_http_version 1.1;
    proxy_pass http://$endpoint_addr:48087;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_cache_bypass $http_upgrade;
  }
}

```
2. Restart nginx
```
service nginx restart
```

## Integration with Apache
1. Make sure that the following Apache modules are in use: `proxy`, `rewrite`, `proxy_http`, `proxy_wstunnel`. On _apache2_, the following command activates these modules,  whenever they are not already enabled:
```
sudo a2enmod proxy rewrite proxy_http proxy_wstunnel
```
2. Add the following directives to the _https_ virtual host `bbb.example.com`:
```
ProxyPreserveHost On

RewriteEngine On
RewriteCond %{HTTP:UPGRADE} ^WebSocket$ [NC,OR]
RewriteCond %{HTTP:CONNECTION} ^Upgrade$ [NC]
RewriteRule .* ws://127.0.0.1:48087%{REQUEST_URI} [P,QSA,L]

<Location />
	Require all granted
	ProxyPass http://127.0.0.1:48087/
	ProxyPassReverse http://127.0.0.1:48087/
</Location>
```
3. Restart Apache:
```
service apache2 restart
```
