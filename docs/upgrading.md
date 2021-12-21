# How To Upgrade bbb-docker

### Upgrading `v2.3.x` -> `v2.4.x`
*Breaking change:* The nginx port changes from `8080` to the less common port `48087`, to avoid port conflicts (see [#133](https://github.com/bigbluebutton/docker/issues/133)). If you use an reverse proxy not included in this repo, ensure to update your config accordingly!

apart from that follow the guide below.

### within `v2.4.x` or `v2.3.x`
#### Backup
if you use greenlight, create a database backup first
```bash
docker exec -t docker_postgres_1 pg_dumpall -c -U postgres > /root/greenlight_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

#### Upgrading
```bash
# upgrade!
./scripts/upgrade

# restart updated services
docker-compose up -d
```
