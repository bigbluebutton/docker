# BigBlueButton Docker

## 1. Install docker-ce

This container depends on docker-ce.

1 - Make sure you don't have docker installed:
`sudo apt-get remove docker docker-engine docker.io`

2 - Install docker-ce:
```
sudo apt-get update;
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce

sudo addgroup `whoami` docker

```

## 2. Clone this repository
```
mkdir -p ~/bbb/src/
cd ~/bbb/
git clone https://github.com/bigbluebutton/docker.git
cd docker
git checkout v2.3.x
```

## 3. Clone BBB sources repository (optional)
```
cd ~/bbb/src/
git clone https://github.com/bigbluebutton/bigbluebutton.git
```

## 4. Setup SSL certificate
Generate a certificate to your container (using letsencrypt or other solution) and then copy your certificate to certs/ folder with the commands:
```
mkdir certs/
cp fullchain.pem certs/
cp privkey.pem certs/
```

## 5. Creating container
In order to create the container you must specify the hostname of container and the domain name.

In this example your container will be acessible from https://bbb001.bbbvm.imdt.com.br :

```
docker-compose build bbb
NAME=bbb001 DOMAIN=bbbvm.imdt.com.br sh -c 'docker-compose run --name $NAME bbb'
```
## 6. Add an entry in your `/etc/hosts` file

In order to access the container, you need to get the IP address of container by running the following command:

```
docker exec -it bbb001 ifconfig eth0
```

After that, add a line in your `/etc/hosts` file with the full domain name specified at previous step.

In this example, the line added on hosts file is:
```
172.20.0.2      bbb001.bbbvm.imdt.com.br
```

## 7. Open the specified address in your browser:

http://bbb001.bbbvm.imdt.com.br


# Useful commands

## Start container (after host reboot)
```
docker start bbb001
docker attach bbb001
```

## Stop the container
```
docker stop bbb001
```

## Kill the container (force exit)
```
docker kill bbb001
```

# MAC users
Docker for Mac OS doesn't allow direct access to container IP's.

In order to access the BBB container from your MAC os host, you can use openvpn:

1. Build containers:
```
docker-compose build mac_proxy mac_openvpn
```

2. Start containers
```
docker-compose up mac_proxy mac_openvpn
```

After it finishes ( until it shows "Initialization Sequence Completed" ), hit CTRL+C.

3. Add `comp-lzo no` at bottom of `mac-vpn/docker-for-mac.ovpn`

4. Install openvpn configuration generated on `mac-vpn/docker-for-mac.ovpn` (double click and open on Tunnelblick)

5. Start containers again
```
docker-compose up mac_proxy mac_openvpn
```
