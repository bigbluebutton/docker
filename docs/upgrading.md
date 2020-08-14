# How To Upgrade bbb-docker

## Backup
if you use greenlight, create a database backup first
```bash
docker exec -t docker_postgres_1 pg_dumpall -c -U postgres > /root/greenlight_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

## Upgrading
```bash
# upgrade!
./scripts/upgrade

# restart updated services
./scripts/compose up -d
```


## "no such file or directory: ./scripts/upgrade"
If you're on an old version, you might get this error. 
A simple `$ git pull` resolves that, by fetching a newer version which includes the upgrade script.
