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
## import ssh keys
import ssh keys for devices you want to allow ssh for
```bash
ssh-import-id gh:<githubusername>
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
2. change the name of the network in the `docker-compose.yaml` files to match the created network
2. navigate to the directory of the service 
```bash
cd ~/docker_services/[service]
```
2. deploy the service
```bash
docker compose up -d
```
3. repeat the steps for each service
