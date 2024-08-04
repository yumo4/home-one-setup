# requirements
## ubuntu server install

## general setup
1. update / upgrade
```bash
sudo apt update
sudo apt upgrade -y
```
2. install shell, nvim, tmux and dependencies
```bash
sudo apt install neovim lua5.3 liblua5.3-dev luarocks tmux stow curl apache2-utils openssh-server net-tools neofetch lsd tree argon2 -y
```
3. clone dotfiles
    1. create a git directory
    ```bash
    mkdir git
    ```
    2. go into the git directory
    ```bash
    cd ~/git
    ```
    3. clone the repo
    ```bash
    git clone https://github.com/yumo4/dotfiles.git
    ```
    4. navigate in common
    ```bash
    cd dotfiles/common
    ```
    5. create symlinks for nvim and tmux
    ```bash
    stow -t ~ .
    ```

## install docker
1. apt setup
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
2. install docker packages
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
3. test the installation
```bash
sudo docker run hello-world
```
4. docker group
```bash
sudo groupadd docker
```
```bash
sudo usermod -aG docker $USER
```

# set up the services
## spin up the docker containers
1. create a new docker network
```bash
docker network create docker_network
```
2. change the name of the network in the ```docker-compose.yaml``` files to match the created network
2. navigate to the directory of the service 
```bash
cd ~/docker_services/[service]
```
2. deploy the service
```bash
docker compose up -d
```
3. repeat the steps for each service

## pihole
### before starting the container
follow the steps ```Installing on  Ubuntu and Fedora``` on the [pi-hole github](https://github.com/pi-hole/docker-pi-hole/#running-pi-hole-docker) / [this video](https://www.youtube.com/watch?v=yCNggtbC_NY&list=PLewY_6N-bfxT8sjHSdqTjIFdhl8FlpYo1&index=5) starting at 8:00
```bash
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
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
5. set up a proxy-host in nginx-proxy manager
- follow the steps in ```nginx-proxy-manager 5.1```
- before saving click on ```Advanced``` and add the following and replace ```IP_ADDRESS``` with the server ip
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
    proxy_pass http://IP_ADDRESS.168.178.65:8080/admin/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_hide_header X-Frame-Options;
    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_read_timeout 90;
}
```
## hompage
1. get ```uid``` and ```gid```
```bash
id
```
2. create ```.env``` file and add ```uid``` and ```gid```
```bash
vim .env
```
```
PUID=[PUID]
PGID=[PGID]
```
3. start container
in docker_services/homepage
```bash
docker-compose up -d
```
this creates the config folder
4. 
## nginx-proxy-manager
1. first log-in
default-email
```
admin@example.com
```
default-password
```
changeme
```
2. setup a new user with username, email and password
3. create a ssl certificate
- go to ```ssl certificate``` and click on ```add ssl cetificate```
    - add the domain name (exampledomain.duckdns.org) and a wildcard (*.exampledomain.duckdns.org) in ```Domain Names```
    - match the ```Email Adress for Let's Encrypt``` with the email you used for ```duckdns```
    - tick both ```Use a DNS Challange``` and ```I Agree to the Let's Encrypt Terms of Service```
    - choose ```DuckDNS``` as the ```DNS Provider```
    - replace ```your-duckdns-token``` with the token from duckdns 
    - set ```Propagation Seconds``` to ```120```
4. FRITZ!Box setup
- navigate to ```Internet>Freigaben```
4.1 in ```Portfreigaben``` click ```Gerät für Freigaben hinzufügen```
    - select your device 
    - click on ```Neue Freigabe``` and choose ```Portfreigabe``` and setup ```HTTP-Server``` and ```HTTPS-Server``` and select ```Internetzugriff über IPv4```
4.2 in ```DynDNS``` click on ```DynDNS benutzen```
    - Update-URL
    ```
     https://www.duckdns.org/update?domains=<your duckdns subdomain>&token=<your token>&ip=<ipaddr>&ipv6=
    ```
    - Domainname
    ```
    <your duckdns subdomain>.duckdns.org
    ```
    - Benutzername
    ```
    none
    ```
    - Kennwort
    ```
    <your token>
    ```
5. create proxy-hosts
- in nginx-proxy-manager click on ```Hosts``` and then ```Proxy Hosts```
- click on ```Add Proxy Host```
    - set a domain in ```Domain Names```
    ```
    exampleservice.yourdomain.duckdns.org
    ```
    - select the ```Scheme``` based on the application
    - select the IP for your server as ```Forward Hostname / IP```
    - select the port of your application as the ```Forward Port```
    - tick (```Chache Assets``` optional) ```Block Common Exploits``` and ```Websocket Support```
    - select ```SSL``` and choose the certificate from ```3.```
    - tick ```Force SSL```
    - save
## Vaultwarden
1. create admin token
replace ```Password``` with your password
```bash
# Using the Bitwarden defaults
echo -n "Password" | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
```
when setting the ```ADMIN_TOKEN``` in the ```.env``` file add an extra ```$``` before each ```$``` in the password hash output 
2. create SMTP password in gmail
- go to ```Google Konto verwalten```
- search for ```App Passwort```
- crate an app password
- add everything to ```.env``` 
3. open ```ip-adress:port/admin```
4. navigate to ```user``` and invite a user
5. open the mail click accept and create a new account

[video tutorial](https://www.youtube.com/watch?v=LoSgi3ei3nk)
