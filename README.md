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
    - `qmcgaw:caddy-scratch` / 35.5MB / Based on [Caddy v2.0.0](https://github.com/caddyserver/caddy/releases/tag/v2.0.0)
    - `qmcgaw:caddy-scratch:v2.00` / 35.5MB / Based on [Caddy v2.0.0](https://github.com/caddyserver/caddy/releases/tag/v2.0.0)
    - `qmcgaw:caddy-scratch:v1.05` / 17.2MB / Based on [Caddy v1.0.5](https://github.com/caddyserver/caddy/releases/tag/v1.0.5)
    - `qmcgaw:caddy-scratch:v1.04` / 17.3MB / Based on [Caddy v1.0.4](https://github.com/caddyserver/caddy/releases/tag/v1.0.4)

## Setup

1. Launch the container

    ```sh
    docker run -d \
    -v $(pwd)/Caddyfile:/Caddyfile:ro \
    -v $(pwd)/data:/data \
    -v $(pwd)/srv:/srv:ro \
    -e TZ=America/Montreal \
    -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp \
    qmcgaw/caddy-scratch
    ```

    or use [docker-compose.yml](https://github.com/qdm12/caddy-scratch/blob/master/docker-compose.yml) with:

    ```sh
    docker-compose up -d
    ```

### Plugins

#### Caddy v2.0.x

Note that many Caddy plugins **do not work yet** on Caddy 2

If you want to have for example the `github.com/caddyserver/ntlm-transport` plugin, build the image with

```sh
docker build -t qmcgaw/caddy \
    --build-arg PLUGINS=github.com/caddyserver/ntlm-transport \
    https://github.com/qdm12/caddy-scratch.git
```

#### Caddy v1.0.x

If you want to have for example the `minify` and the `ipfilter` plugins, build the image with:

```sh
docker build -t qmcgaw/caddy --build-arg PLUGINS=minify,ipfilter https://github.com/qdm12/caddy-scratch.git#v1.0.5
```

### Re-enable telemetry

Telemetry is disabled by default. You can enable it by building the image with:

```sh
docker build -t qmcgaw/caddy --build-arg TELEMETRY=true https://github.com/qdm12/caddy-scratch.git
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
