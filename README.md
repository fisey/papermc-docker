# PaperMC – The High Performance Fork - Docker setup
This is an example setup for papermc minecraft server in docker.

Everything you may need is included in this repository.

This setup run on 1.15.2 but it's easy to change.


## Topics

1. How to setup
2. How to maintain
3. How to backup


### 1. How to setup
As written this setup is for docker. So you need to install `docker` and `docker-compose` on your local system / server.

- [Install docker-ce](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Install docker-compose](https://docs.docker.com/compose/install/)

Create a folder `/etc/docker-compose` and clone everything from this repository inside.
```bash
mkdir --parents /etc/docker-compose
git clone https://github.com/fisey/papermc-docker.git /etc/docker-compose/minecraft
```

Create a new user with the `uid 4321` without a password.
```bash
adduser --disabled-password --uid 4321 --gecos "" minecraft
```

Create a `minecraft-data` under `/srv/`.
```bash
mkdir --parents /srv/minecraft-data
chown minecraft:minecraft /srv/minecraft-data
```

Build docker container.
```bash
cd /etc/docker-compose/minecraft
docker-compose build
```

Run docker container.
```bash
cd /etc/docker-compose/minecraft
docker-compose up
```


### 2. How to maintain
For example there comes a point where you want to update the version. With docker this is easy. You just need to add two new lines into your `docker-compose.yml`.

Find the download here [PaperMC Downloads](https://papermc.io/downloads).

*Change version*
```bash
---

version: '3.5'

services:
  minecraft-server:
    build: .
    ports:
    - 25565:25565
    container_name: minecraft-server
    restart: always
    environment:
    - APP_UID=4321
    - APP_GID=4321
    - APP_MEMORY=8192M
    - APP_BUILD=<build_number>
    - APP_VERSION=<build_version>
    volumes:
    - /srv/minecraft-data:/minecraft-data

...
```

*Stop minecraft server*
```bash
cd /etc/docker-compose/minecraft
docker-compose down
```

*Start minecraft server*
```bash
cd /etc/docker-compose/minecraft
docker-compose up
```


### 3. How to backup
tbd