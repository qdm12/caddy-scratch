# Caddy Scratch Docker

*Caddy server 1.0.3 with optional plugins on a Scratch Docker image*

[![caddy-scratch](https://github.com/qdm12/caddy-scratch/raw/master/title.jpg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![Docker Build Status](https://img.shields.io/docker/cloud/build/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![Image size](https://images.microbadger.com/badges/image/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)

| Image size | RAM usage | CPU usage |
| --- | --- | --- |
| 15.8MB | 18MB | Low |

It is based on:

- [Scratch](https://hub.docker.com/_/scratch/)
- [Caddy 1.0.3](https://github.com/mholt/caddy) built with Go 1.3 and Alpine 3.10

Features:

- Runs **without** root
- Plugins can easily be plugged in
- Scratch based, so less attack surface
- Instructions to build for ARM devices below

## Setup

1. <details><summary>CLICK IF YOU HAVE AN ARM DEVICE</summary><p>

    - If you have a ARM 32 bit v6 architecture

        ```sh
        docker build -t qmcgaw/caddy-scratch \
        --build-arg BASE_IMAGE_BUILDER=arm32v6/golang \
        --build-arg GOARCH=arm \
        --build-arg GOARM=6 \
        --build-arg PLUGINS= \
        https://github.com/qdm12/caddy-scratch.git
        ```

    - If you have a ARM 32 bit v7 architecture

        ```sh
        docker build -t qmcgaw/caddy-scratch \
        --build-arg BASE_IMAGE_BUILDER=arm32v7/golang \
        --build-arg GOARCH=arm \
        --build-arg GOARM=7 \
        --build-arg PLUGINS= \
        https://github.com/qdm12/caddy-scratch.git
        ```

    - If you have a ARM 64 bit v8 architecture

        ```sh
        docker build -t qmcgaw/caddy-scratch \
        --build-arg BASE_IMAGE_BUILDER=arm64v8/golang \
        --build-arg GOARCH=arm64 \
        --build-arg PLUGINS= \
        https://github.com/qdm12/caddy-scratch.git
        ```

    </p></details>

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

If you want to have for example the `minify` and the `ipfilter` plugins for example, build the image with:

```sh
docker build -t qmcgaw/caddy --build-arg PLUGINS=minify,ipfilter https://github.com/qdm12/caddy-scratch.git
```

### Re-enable telemetry

Telemetry is disabled by default. You can enable it by building the image with:

```sh
docker build -t qmcgaw/caddy --build-arg TELEMETRY=true https://github.com/qdm12/caddy-scratch.git
```

## Little tricks

- Hot reload the Caddyfile with

    ```sh
    docker kill --signal=USR1 caddy
    ```

## TODOs

- [ ] Tzdata
- [ ] Use lists of IPs to block with ipfilter with `import blockIps`
- [ ] Healthcheck for Caddy
- [ ] Intelligent IP blocking

## License

This repository is under an [MIT license](https://github.com/qdm12/caddy-scratch/master/license)

## Thanks

- To the Caddy developers and mholt especially
- To the Caddy plugins developers
- To abiosoft for helping me out building this Docker image
