# Vaultwarden
1. create admin token
replace `Password` with your password
```bash
# Using the Bitwarden defaults
echo -n "Password" | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
```
## .env
```bash
ADMIN_TOKEN= # randomly generated string of characters, for example running openssl rand -base64 48
WEBSOCKET_ENABLED=true
SIGNUPS_ALLOWED=false #true ##change to false once create the admin account
DOMAIN= https://vaultwarden.example.com #replace example.com with your domain
INVITATION_ORG_NAME=
# INVITATIONS_ALLOWED=
WEB_VAULT_ENABLED=true
SMTP_HOST=smtp.gmail.com
SMTP_FROM=Vaultwarden
SMTP_PORT=465 # 587
SMTP_SECURITY=force_tls
SMTP_USERNAME= maximilian.troe@gmail.com #user@example.com 
SMTP_PASSWORD=  # gmail smtp password for vautlwarden

```
when setting the `ADMIN_TOKEN` in the `.env` file add an extra `$` before each `$` in the password hash output 
### mailing
1. create SMTP password in gmail
- go to `Google Konto verwalten`
- search for `App Passwort`
- crate an app password
- add everything to `.env` 
## user setup
1. open `ip-adress:port/admin`
2. navigate to `user` and invite a user
3. open the mail click accept and create a new account

[video tutorial](https://www.youtube.com/watch?v=LoSgi3ei3nk)

## start the container
```bash
docker compose up -d
```
## nginx-proxy-manager
for setting up a proxy host with nginx-proxy-manager
- use `http` NOT `https`
- Port: `9090`
- Websockets Support
- Force SSL (select the SSL Certificate)
