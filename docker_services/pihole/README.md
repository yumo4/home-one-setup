# pihole
## before starting the container
follow the steps ```Installing on  Ubuntu and Fedora``` on the [pi-hole github](https://github.com/pi-hole/docker-pi-hole/#running-pi-hole-docker) / [this video](https://www.youtube.com/watch?v=yCNggtbC_NY&list=PLewY_6N-bfxT8sjHSdqTjIFdhl8FlpYo1&index=5) starting at 8:00
```bash
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
```
## start the container
```bash
docker compose up -d
```
## configuration
1. setup dns server in router
fritzbox: ```Internet > Zugansdaten: DNS-Server```
go to ```DNSv4-Server``` select ```Andere DNSv4-Server verwenden``` and fill in the ip address of your server 
2. change the password
    1. open the container terminal
    ```bash
    docker exec -it pihole /bin/bash
    ```
    2. change the password
    ```bash
    sudo pihole -a -p [newpassword]
    ```

    or using portainer

    1. edit the Container
    click on ```Duplicate/Edit```
    2. change the password
    scroll all the way down to ```Advanced container settings``` and click on ```Env```
    change the ```value``` of ```WEBPASSWORD``` to the new password
    3. deploy the changes
    scroll up a bit and click on ```Deploy the container``` at the bottom of the "main-box" of the overview

3. add whitelists
in the webportal navigate to ```Domains``` and add these to the whitelist
```
dyn.sport api.dyn.sport api.mixpanel.com portal.blindeninstitut.de
```
4. add adlists
in the webportal navigate to ```Adlists``` and add these from [firebog](https://firebog.net/)
```
https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts https://v.firebog.net/hosts/static/w3kbl.txt https://adaway.org/hosts.txt https://v.firebog.net/hosts/AdguardDNS.txt https://v.firebog.net/hosts/Admiral.txt https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt https://v.firebog.net/hosts/Easylist.txt https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts https://v.firebog.net/hosts/Easyprivacy.txt https://v.firebog.net/hosts/Prigent-Ads.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt https://v.firebog.net/hosts/Prigent-Crypto.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt https://phishing.army/download/phishing_army_blocklist_extended.txt https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt https://v.firebog.net/hosts/RPiList-Malware.txt https://v.firebog.net/hosts/RPiList-Phishing.txt https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts https://urlhaus.abuse.ch/downloads/hostfile/ https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser
```

## nginx-proxy-manager
for setting up a proxy host with nginx-proxy-manager
- use `http` NOT `https`
- Port: `8080`
- Websockets Support, Block Common Exploits
- Force SSL (select the SSL Certificate)
- In `Advanced` add the following and ***replace*** `IP_ADDRESS` with the Server IP
```
location / {
    proxy_pass http://IP_ADDRESS:8080/admin/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_hide_header X-Frame-Options;
    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_read_timeout 90;
}

location /admin/ {
    proxy_pass http://IP_ADDRESS:8080/admin/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_hide_header X-Frame-Options;
    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_read_timeout 90;
}
```
