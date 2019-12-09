# BigBlueButton Docker

## Setting up the SSL
Generate a certificate to your container using letsencrypt and then copy your certificate to certs/ folder with the commands:
```
mkdir certs/
cp fullchain.pem certs/
cp privkey.pem certs/
```

## Creating container
```
docker-compose build bbb
NAME=bbb001 DOMAIN=bbbvm.imdt.com.br sh -c 'docker-compose run --name $NAME bbb'
```

## Defining an entry in your `/etc/hosts` file
```
docker exec -it bbb001 ifconfig eth0
```

## MAC users
Docker for Mac OS doesn't allow direct access to container IP's.

In order to access the BBB container from your MAC os host, you can use openvpn:

1. Build containers:
```
docker-compose build mac_proxy mac_openvpn
```

2. Add `comp-lzo no` at bottom of `mac-vpn/docker-for-mac.ovpn`

3. Install openvpn configuration generated on `mac-vpn/docker-for-mac.ovpn` (double click and open on Tunnelblick)

4. Start containers
```
docker-compose start mac_proxy mac_openvpn
```
