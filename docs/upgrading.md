# How To Upgrade bbb-docker

### within `2.3.x
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


### from `2.2.x` to `2.3.x`

```bash
cd bbb-docker

# if you use greenlight: create a database backup
./scripts/compose exec postgres pg_dumpall -c -U postgres > /root/bbb-docker-2.2-backup.sql

# stop bbb-docker
./scripts/compose down

# go back and rename folder
cd ..
mv bbb-docker bbb-docker-2.2-archived

# get bbb-docker 2.3
git clone --recurse-submodules https://github.com/bigbluebutton/docker.git bbb-docker
cd bbb-docker

# do setup
./scripts/setup

# optionally do additional changes
nano .env

# regenerate the docker-compose file
./scripts/generate-compose

# if you use greenlight, import database backup
docker-compose up -d postgres
cat /root/bbb-docker-2.2-backup.sql | docker-compose exec -T postgres psql -U postgres

# start new BBB 2.3
docker-compose up -d


```
- `$ cd bbb-docker`
- (if you use greenlight) create a database backup first
