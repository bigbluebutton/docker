# How To Upgrade bbb-docker

### Breaking changes `v2.7.x` -> `v3.0.x`
- **A setup behind NAT does currently not work!**
- on every SIP Profiles the extension field needs to be set to "DIALIN" 

### Breaking changes `v2.6.x` -> `v2.7.x`
- We use now Docker Compose V2
    * make sure you have docker ≥ 23.0 installed (`$ docker -v`)
    * update all usages of `docker-compose` to `docker compose` in your scripts

### Breaking changes `v2.5.x` -> `v2.6.x`
- Greenlight got fully rewritten
    * it is starting as a fresh installation. you can migrate your data with `./scripts/greenlight-migrate-v2-v3`
    * some greenlight settings under `.env` have changed. compare your version with `sample.env`
    * it is now served directly under `/` and not in `/b`. If you use an reverse proxy not included in this repo, ensure to update your config accordingly!

### Backup
if you use greenlight, create a database backup first
```bash
docker exec -t docker_postgres_1 pg_dumpall -c -U postgres > /root/greenlight_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

### Upgrading
```bash
# upgrade!
./scripts/upgrade

# restart updated services
docker compose up -d --no-build
```
