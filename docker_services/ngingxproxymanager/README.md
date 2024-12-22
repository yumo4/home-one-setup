# nginx-proxy-manager
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
- go to `ssl certificate` and click on `add ssl cetificate`
    - add the domain name (exampledomain.duckdns.org) and a wildcard (*.exampledomain.duckdns.org) in `Domain Names`
    - match the `Email Adress for Let's Encrypt` with the email you used for `duckdns`
    - tick both `Use a DNS Challange` and `I Agree to the Let's Encrypt Terms of Service`
    - choose `DuckDNS` as the `DNS Provider`
    - replace `your-duckdns-token` with the token from duckdns
    - set `Propagation Seconds` to `120`
4. FRITZ!Box setup
- navigate to `Internet>Freigaben`
4.1 in `Portfreigaben` click `Gerät für Freigaben hinzufügen`
    - select your device 
    - click on `Neue Freigabe` and choose `Portfreigabe` and setup `HTTP-Server` and `HTTPS-Server` and select `Internetzugriff über IPv4`
4.2 in `DynDNS` click on `DynDNS benutzen`
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
## proxy-hosts
- in nginx-proxy-manager click on ``Hosts` and then `Proxy Hosts`
- click on `Add Proxy Host`
    - set a domain in `Domain Names`
    ```
    exampleservice.yourdomain.duckdns.org
    ```
    - select the `Scheme` based on the application
    - select the IP for your server as `Forward Hostname / IP`
    - select the port of your application as the `Forward Port`
    - tick (`Chache Assets` optional) `Block Common Exploits` and `Websocket Support`
    - select `SSL` and choose the certificate from `3.`
    - tick `Force SSL`
    - save
