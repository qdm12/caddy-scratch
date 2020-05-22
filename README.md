# Caddy Scratch Docker

*Caddy server 2.0.0 / 1.0.5 without root, without OS and with optional Caddy plugins*

<img height="200" src="https://raw.githubusercontent.com/qdm12/caddy-scratch/master/title.svg?sanitize=true">

[![Build status](https://github.com/qdm12/caddy-scratch/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/caddy-scratch/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Image size](https://images.microbadger.com/badges/image/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)

[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)

## Features

- [Scratch](https://hub.docker.com/_/scratch/) based, so less attack surface and tiny
- Runs **without** root
- Plugins can easily be added by building the Docker image with a build argument
- Compatible with `amd64`, `386` and `arm64` CPU architectures
- [Docker image tags and sizes](https://hub.docker.com/r/qmcgaw/caddy-scratch/tags)
    - `qmcgaw:caddy-scratch` / 35.4MB / Based on [Caddy v2.0.0](https://github.com/caddyserver/caddy/releases/tag/v2.0.0) and Alpine 3.11
    - `qmcgaw:caddy-scratch:v1.0.5` / 17.2MB / Based on [Caddy v1.0.5](https://github.com/caddyserver/caddy/releases/tag/v1.0.5) / [**Documentation**](https://github.com/qdm12/caddy-scratch/blob/dd9e13597f99228b8dcf769155a1af67268aeaf2/README.md)
    - `qmcgaw:caddy-scratch:v1.0.4` / 17.3MB / Based on [Caddy v1.0.4](https://github.com/caddyserver/caddy/releases/tag/v1.0.4) / [**Documentation**](https://github.com/qdm12/caddy-scratch/blob/d387849664b0df7b931a31113017b70a0ebe18cc/README.md)

## Setup

1. Launch the container

    ```sh
    docker run -d -e TZ=America/Montreal \
    -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp \
    qmcgaw/caddy-scratch
    ```

    or use [docker-compose.yml](https://github.com/qdm12/caddy-scratch/blob/master/docker-compose.yml) with:

    ```sh
    docker-compose up -d
    ```

### Bind mount

The data is persistent in a Docker anonymous volume by default.
If you want to bind mount the data:

1. Create the directory structure: `mkdir -p /yourpath/caddydir/data`
1. Either `touch /yourpath/caddydir/Caddyfile` or place your Caddyfile there
1. Set the right ownership and permissions for the container

    ```sh
    chown -R 1000 /yourpath/caddydir
    chmod -R 700 /yourpath/caddydir
    ```

    Alternatively, you can run the container with `--user="1001"` for example, or as root with `--user="root"` (*unadvised*).

1. Run the Docker command with `-v /yourpath/caddydir:/caddydir`

### Plugins

Note that many Caddy plugins **do not work yet** on Caddy 2

If you want to have for example the `github.com/caddyserver/ntlm-transport` plugin, build the image with

```sh
docker build -t qmcgaw/caddy \
    --build-arg PLUGINS=github.com/caddyserver/ntlm-transport \
    https://github.com/qdm12/caddy-scratch.git
```

## Little tricks

- Assuming your container is called `caddy`, you can hot reload the Caddyfile with

    ```sh
    docker kill --signal=USR1 caddy
    ```

## TODOs

- [ ] Use lists of IPs to block with ipfilter with `import blockIps`
- [ ] Healthcheck for Caddy
- [ ] Intelligent IP blocking

## License

This repository is under an [MIT license](https://github.com/qdm12/caddy-scratch/master/license)

## Thanks

- To the Caddy developers and mholt especially
- To the Caddy plugins developers
- To abiosoft for helping me out building this Docker image
