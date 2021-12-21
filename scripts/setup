#!/bin/bash

set -e
cd "$(dirname "$0")/.."

if ! [ -x "$(command -v curl)" ]; then
  echo "Error: curl is not installed, but the setup script relies on it."
  echo "on debian based operating systems try following command:"
  echo "  $ sudo apt-get install curl"
  exit 1
fi

# load .env
if [ -f .env ]
then
  echo "Error: the configuration file .env already exists."
  echo "either edit variables manually in there or remove the file and try this script again"
  exit 1
fi


EXTERNAL_IPv4=$(curl -4 -s https://icanhazip.com)
EXTERNAL_IPv6=$(curl -6 -s -m 10 https://icanhazip.com || true)

greenlight=""
while [[ ! $greenlight =~ ^(y|n)$ ]]; do
    read -p "Should greenlight be included? (y/n): " greenlight
done

https_proxy=""
while [[ ! $https_proxy =~ ^(y|n)$ ]]; do
    read -p "Should an automatic HTTPS Proxy be included? (y/n): " https_proxy
done

coturn=""
while [[ ! $coturn =~ ^(y|n)$ ]]; do
    read -p "Should a coturn be included? (y/n): " coturn
done
if [ "$coturn" == "y" ] && [ ! "$https_proxy" == "y" ]
then
    echo "Coturn needs TLS to function properly."
    echo "   Since automatic HTTPS Proxy is disabled,"
    echo "   you must provide a relative or absolute path"
    echo "   to your certificates."
    while [[ -z "$CERTPATH" ]]; do
        read -p "Please enter path to cert.pem: " CERTPATH
    done
    while [[ -z "$KEYPATH" ]]; do
        read -p "Please enter path to key.pem: " KEYPATH
    done
fi

DOMAIN=""
while [[ -z "$DOMAIN" ]]; do
    read -p "Please enter the domain name: " DOMAIN
done

recording=""
echo "Should the recording feature be included?"
echo "   IMPORTANT: this is currently a big privacy issues, because it will "
echo "   record everything which happens in the conference, even when the button"
echo "   suggests, that it does not."
echo "   make sure that you always get people's consent, before they join a room!"
echo "   https://github.com/bigbluebutton/bigbluebutton/issues/9202"
while [[ ! $recording =~ ^(y|n)$ ]]; do
    read -p "Choice (y/n): " recording
done

prometheus_exporter=""
while [[ ! $prometheus_exporter =~ ^(y|n)$ ]]; do
    read -p "Should a Prometheus exporter be included? (y/n): " prometheus_exporter
done
if [ "$prometheus_exporter" == "y" ]  && [ "$recording" == "y" ]
then
    echo "Should Prometheus exporter optimization be enabled?"
    echo "  This instructs exporter to collect expensive recordings metrics by querying the disk instead of the API."
    echo "  Enabling this can substantially decrease the scrape time required for the exporter to respond to metrics requests"
    prometheus_exporter_optimization=""
    while [[ ! $prometheus_exporter_optimization =~ ^(y|n)$ ]]; do
        read -p "Choice (y/n): " prometheus_exporter_optimization
    done
fi

if [ "$recording" == "y" ]
then

  remove_old_recording=""
  while [[ ! $remove_old_recording =~ ^(y|n)$ ]]; do
      read -p "Should old recordings be removed? (y/n): " remove_old_recording
  done

  if [ "$remove_old_recording" == "y" ]
  then
    recording_max_age_days=""
    while [[ ! $recording_max_age_days =~ ^[0-9]{1,4}$ ]]; do
        read -p "Please enter max age(days) for keeping recordings: " recording_max_age_days
    done
  fi

fi

ip_correct=""
while [[ ! $ip_correct =~ ^(y|n)$ ]]; do
    read -p "Is $EXTERNAL_IPv4 your external IPv4 address? (y/n): " ip_correct
done

if [ ! "$ip_correct" == "y" ]
then
    EXTERNAL_IPv4=""
    while [[ ! $EXTERNAL_IPv4 =~ ^[1-9][0-9]{0,2}\.[0-9]{0,3}\.[0-9]{0,3}\.[1-9][0-9]{0,2}$ ]]; do
        read -p "Please enter correct IPv4 address: " EXTERNAL_IPv4
    done
fi

if [ -n "$EXTERNAL_IPv6" ]
then
    ip_correct=""
    while [[ ! $ip_correct =~ ^(y|n)$ ]]; do
        read -p "Is $EXTERNAL_IPv6 your external IPv6 address? (y/n): " ip_correct
    done

    if [ ! "$ip_correct" == "y" ]
    then
        EXTERNAL_IPv6=""
        while [[ ! $EXTERNAL_IPv6 =~ ^[0-9a-z:]{3,39}$ ]]; do
            read -p "Please enter correct IPv6 address: " EXTERNAL_IPv6
        done
    fi
fi



# write settings
cp sample.env .env
sed -i "s/EXTERNAL_IPv4=.*/EXTERNAL_IPv4=$EXTERNAL_IPv4/" .env
sed -i "s/EXTERNAL_IPv6=.*/EXTERNAL_IPv6=$EXTERNAL_IPv6/" .env
sed -i "s/DOMAIN=.*/DOMAIN=$DOMAIN/" .env

if [ ! "$greenlight" == "y" ]
then
    sed -i "s/ENABLE_GREENLIGHT.*/#ENABLE_GREENLIGHT=true/" .env
fi

if [ ! "$https_proxy" == "y" ]
then
    sed -i "s/ENABLE_HTTPS_PROXY.*/#ENABLE_HTTPS_PROXY=true/" .env
fi

if [ "$recording" == "y" ]
then
    sed -i "s/#ENABLE_RECORDING.*/ENABLE_RECORDING=true/" .env
fi

if [ "$remove_old_recording" == "y" ]
then
    sed -i "s/#REMOVE_OLD_RECORDING=.*/REMOVE_OLD_RECORDING=true/" .env
    sed -i "s/#RECORDING_MAX_AGE_DAYS=.*/RECORDING_MAX_AGE_DAYS=$recording_max_age_days/" .env
fi

if [ "$coturn" == "y" ]
then
    sed -i "s/.*TURN_SERVER=.*/TURN_SERVER=turns:$DOMAIN:5349?transport=tcp/" .env
    TURN_SECRET=$(head /dev/urandom | tr -dc A-Za-f0-9 | head -c 32)
    sed -i "s/.*TURN_SECRET=.*/TURN_SECRET=$TURN_SECRET/" .env
    sed -i "s/.*STUN_IP=.*/STUN_IP=$EXTERNAL_IPv4/" .env
else
    sed -i "s/ENABLE_COTURN.*/#ENABLE_COTURN=true/" .env
fi

if [ -n "$CERTPATH" ] && [ -n "$KEYPATH" ]
then
    sed -i "s,#COTURN_TLS_CERT_PATH=.*,COTURN_TLS_CERT_PATH=$CERTPATH," .env
    sed -i "s,#COTURN_TLS_KEY_PATH=.*,COTURN_TLS_KEY_PATH=$KEYPATH," .env
fi

if [ "$prometheus_exporter" == "y" ]
then
    sed -i "s/#ENABLE_PROMETHEUS_EXPORTER=.*/ENABLE_PROMETHEUS_EXPORTER=true/" .env
fi

if [ "$prometheus_exporter_optimization" == "y" ]
then
    sed -i "s/#ENABLE_PROMETHEUS_EXPORTER_OPTIMIZATION=.*/ENABLE_PROMETHEUS_EXPORTER_OPTIMIZATION=true/" .env
fi

# change secrets
RANDOM_1=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
RANDOM_2=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
RANDOM_3=$(head /dev/urandom | tr -dc a-f0-9 | head -c 128)
RANDOM_4=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
RANDOM_5=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)

sed -i "s/SHARED_SECRET=.*/SHARED_SECRET=$RANDOM_1/" .env
sed -i "s/ETHERPAD_API_KEY=.*/ETHERPAD_API_KEY=$RANDOM_2/" .env
sed -i "s/RAILS_SECRET=.*/RAILS_SECRET=$RANDOM_3/" .env
sed -i "s/FSESL_PASSWORD=.*/FSESL_PASSWORD=$RANDOM_4/" .env
sed -i "s/POSTGRESQL_SECRET=.*/POSTGRESQL_SECRET=$RANDOM_5/" .env

./scripts/generate-compose

echo "--------------------------------------------------"
echo "configuration file .env got successfully created!"
echo ""
echo "you can look through it for further adjusments"
echo "  $ nano .env"
echo ""
echo "make sure to recreate the docker-compose.yml after each change"
echo "  $ ./scripts/generate-compose"
echo ""
echo "to start bigbluebutton run"
echo "  $ docker-compose up -d"
