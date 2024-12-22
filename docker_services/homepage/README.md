# homepage
## .env
1. get `uid` and `gid`
```bash
id
```
2. create `.env` file and add `uid` and `gid`
```bash
vim .env
```
replace `[PUID]` and `[PGID]` in the `.env` file
```bash
PUID=[PUID]
PGID=[PGID]
```
## start the container
```bash
docker compose up -d
```

## nginx-proxy-manager
for setting up a proxy host with nginx-proxy-manager
- use `http` NOT `https`
- Port: `3000`
- Websockets Support
- Force SSL (select the SSL Certificate)
