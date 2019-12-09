# BigBlueButton Docker

## Setting up the SSL
Generate a certificate to your container using letsencrypt and then copy your certificate to certs/ folder with the commands:
```
mkdir certs/
cp fullchain.pem certs/
cp privkey.pem certs/
```

## Creating container
In order to create the container you must specify the hostname of container and the domain name.

In this example your container will be acessible from https://bbb001.bbbvm.imdt.com.br :

```
docker-compose build bbb
NAME=bbb001 DOMAIN=bbbvm.imdt.com.br sh -c 'docker-compose run --name $NAME bbb'
```
## Defining an entry in your `/etc/hosts` file

In order to access the container, you need to get the IP address of container by running the following command:

```
docker exec -it bbb001 ifconfig eth0
```

After that, add a line in your `/etc/hosts` file with the full domain name specified at previous step.

In this example, the line added on hosts file is:
```
172.20.0.2      bbb001.bbbvm.imdt.com.br
```

## Useful commands

### Start container (after host reboot)
```
docker start bbb001
docker attach bbb001
```

### Stop the container
```
docker stop bbb001
```

### Kill the container (force exit)
```
docker kill bbb001
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
