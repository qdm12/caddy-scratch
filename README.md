# Caddy Scratch Docker

*Caddy server 1.0.0 with optional plugins on a Scratch Docker image*

[![Docker Build Status](https://img.shields.io/docker/build/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/caddy-scratch.svg)](https://github.com/qdm12/caddy-scratch/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)
[![Docker Automated](https://img.shields.io/docker/automated/qmcgaw/caddy-scratch.svg)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![Image size](https://images.microbadger.com/badges/image/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/caddy-scratch.svg)](https://microbadger.com/images/qmcgaw/caddy-scratch)

| Image size | RAM usage | CPU usage |
| --- | --- | --- |
| 15.8MB |  |  |

It is based on:

- [Scratch](https://hub.docker.com/_/scratch/)
- [Caddy 1.0.0](https://github.com/mholt/caddy) built with Go 1.12.5 and Alpine 3.9

## Setup

Use the following command:

```bash
docker run -d \
-v $(pwd)/Caddyfile:/Caddyfile:ro \
-v $(pwd)/data:/data \
-v $(pwd)/srv:/srv:ro \
-p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp \
qmcgaw/caddy-scratch
```

or use [docker-compose.yml](https://github.com/qdm12/caddy-scratch/blob/master/docker-compose.yml) with:

```bash
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

## TODOs

- [ ] Use lists of IPs to block with ipfilter with `import blockIps`
- [ ] Healthcheck for Caddy
- [ ] Fix reloading of Caddyfile with SIGUSR1
- [ ] Intelligent IP blocking

## License

This repository is under an [MIT license](https://github.com/qdm12/caddy-scratch/master/license)

## Thanks

- To the Caddy developers and mholt especially
- To the Caddy plugins developers
- To abiosoft for helping me out building this Docker image
