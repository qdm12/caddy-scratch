# Caddy Scratch Docker

*Caddy server 1.0.4 all in 17.3MB without root, without OS and with optional Caddy plugins*

<img height="200" src="title.svg?sanitize=true">

[![Build status](https://github.com/qdm12/caddy-scratch/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/caddy-scratch/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Image size](https://images.microbadger.com/badges/image/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)

[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)

It is based on:

- [Scratch](https://hub.docker.com/_/scratch/)
- [Caddy 1.0.4](https://github.com/mholt/caddy) built with Go 1.14 on Alpine 3.11

Features:

- Runs **without** root
- Scratch based, so less attack surface
- Plugins can easily be added by building the Docker image with a build argument
- Compatible with `amd64`, `386` and `arm64` CPU architectures
- [Docker image tags and sizes](https://hub.docker.com/r/qmcgaw/caddy-scratch/tags)

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

If you want to have for example the `minify` and the `ipfilter` plugins, build the image with:

```sh
docker build -t qmcgaw/caddy --build-arg PLUGINS=minify,ipfilter https://github.com/qdm12/caddy-scratch.git
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
