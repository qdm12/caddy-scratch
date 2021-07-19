# Caddy Scratch Docker

Caddy server v2.4.1 / v1.0.5 without root, without OS and with optional Caddy plugins

<img height="200" src="https://raw.githubusercontent.com/qdm12/caddy-scratch/master/title.svg">

[![Build status](https://github.com/qdm12/caddy-scratch/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/caddy-scratch/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)

## Features

- [Scratch](https://hub.docker.com/_/scratch/) based, so less attack surface and tiny
- Runs **without** root
- [Plugins](#Plugins)

| Docker tag | Caddy version | Size | Documentation | CPU architectures |
| --- | --- | --- | --- | --- |
| `:latest` | [`v2.4.1`](https://github.com/caddyserver/caddy/releases/tag/v2.4.1) | 37.3MB | ➡️ [Setup below](#Setup) | `amd64`, `386`, `arm64`, `armv7` |
| `:v2.4.1` | [`v2.4.1`](https://github.com/caddyserver/caddy/releases/tag/v2.4.1) | 37.5MB | ➡️ [Setup below](#Setup) | `amd64`, `386`, `arm64`, `armv7` |
| `:2.3.0` | [`v2.3.0`](https://github.com/caddyserver/caddy/releases/tag/v2.3.0) | 37.3MB | ➡️ [Setup below](#Setup) | `amd64`, `386`, `arm64`, `armv7` |
| `:v2.2.1` | [`v2.2.1`](https://github.com/caddyserver/caddy/releases/tag/v2.2.1) | 33.9MB | ➡️ [Setup below](#Setup) | `amd64`, `386`, `arm64`, `armv7` |
| `:v2.1.0` | [`v2.1.0`](https://github.com/caddyserver/caddy/releases/tag/v2.1.0) | 39.2MB | ➡️ [Wiki link](https://github.com/qdm12/caddy-scratch/wiki/Caddy-v2.1.0) | `amd64`, `386`, `arm64`, `armv7` |
| `:v2.0.0` | [`v2.0.0`](https://github.com/caddyserver/caddy/releases/tag/v2.0.0) | 35.4MB | ➡️ [Wiki link](https://github.com/qdm12/caddy-scratch/wiki/Caddy-v2.0.0) | `amd64`, `386`, `arm64`, `armv7` |
| `:v1.0.5` | [`v1.0.5`](https://github.com/caddyserver/caddy/releases/tag/v1.0.5) | 17.2MB | ➡️ [Wiki link](https://github.com/qdm12/caddy-scratch/wiki/Caddy-v1.0.5) | `amd64`, `386`, `arm64` |
| `:v1.0.4` | [`v1.0.4`](https://github.com/caddyserver/caddy/releases/tag/v1.0.4) | 17.3MB | ➡️ [Wiki link](https://github.com/qdm12/caddy-scratch/wiki/Caddy-v1.0.4) | `amd64`, `386`, `arm64` |

Size: *uncompressed amd64 built Docker image*

## Setup

✈️ Migrating from v1.0.x? ➡️ [Wiki: Migrating](https://github.com/qdm12/caddy-scratch/wiki/Migrating)

⚠️ The following applies to the `:latest` tag. For other Docker tags, refer to the [Wiki](https://github.com/qdm12/caddy-scratch/wiki/)

```sh
docker run -d --name caddy -p 80:8080/tcp -p 443:8443/tcp qmcgaw/caddy-scratch
```

or use [docker-compose.yml](https://github.com/qdm12/caddy-scratch/blob/master/docker-compose.yml) with:

```sh
docker-compose up -d
```

The data is persistent in a Docker anonymous volume by default.

### Caddyfile

By default, this runs using the [repository Caddyfile](https://github.com/qdm12/caddy-scratch/blob/master/Caddyfile).
You could work you way out modifying the Caddy configuration using the [Caddy API](#Caddy-API). Otherwise, if you want to use a Caddyfile, follow these steps.

1. Create the directory: `mkdir caddydir`
1. Create a [Caddyfile](https://caddyserver.com/docs/caddyfile) with the content you would like, in `caddydir/Caddyfile`.
   Note that at the top of your *Caddyfile*, there should be at least the following global block:

    ```Caddyfile
    {
        http_port 8080
        https_port 8443
    }
    ```

1. Change the ownership and permission to match the Docker container

    ```sh
    chown -R 1000 caddydir
    chmod -R 700 caddydir
    ```

    If you are on Windows, you may skip this step.

    Alternatively, you can run the container with `--user="1001"` for example, or as root with `--user="root"` (*unadvised*).

1. Assuming your current file path is `/yourpath`, run the container with:

    ```sh
    docker run -d --name caddy -p 80:8080/tcp -p 443:8443/tcp \
        -v /yourpath/caddydir:/caddydir qmcgaw/caddy-scratch
    ```

### Log times

If log times are not correct, it's because you need to set your timezone in the `TZ` environment variable. For example, add `-e TZ=America/Montreal` to your Docker run command.

### Update

Update the docker image with `docker pull qmcgaw/caddy-scratch`

### Caddy API

To access the [Caddy API](https://caddyserver.com/docs/api), you need:

- your Caddyfile to contain `admin 0.0.0.0:2019` at the top global block (as is in the default Caddyfile)
- (eventually) have port 2019 published by adding `-p 2019:2019/tcp` to your Docker run command

### Plugins

You need [Git](https://git-scm.com/downloads) installed.

If you want to have for example the `github.com/caddyserver/ntlm-transport` plugin, build the image with

```sh
docker build -t qmcgaw/caddy \
    --build-arg PLUGINS=github.com/caddyserver/ntlm-transport \
    https://github.com/qdm12/caddy-scratch.git
```

## Extra

- Assuming your container is called `caddy`, you can reload the Caddyfile with:

    ```sh
    docker kill --signal=USR1 caddy
    ```

## TODOs

- [ ] Telemetry off with build argument
- [ ] Use lists of IPs to block with ipfilter with `import blockIps`
- [ ] Healthcheck for Caddy
- [ ] Intelligent IP blocking

## License

This repository is under an [MIT license](https://github.com/qdm12/caddy-scratch/master/license)

## Thanks

- To the Caddy developers and mholt especially
- To the Caddy plugins developers
- To abiosoft for helping me out building this Docker image
