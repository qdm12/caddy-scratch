# Caddy Scratch Docker

*Caddy server with plugins on a Scratch base Docker image*

[![caddy-scratch](https://github.com/qdm12/caddy-scratch/raw/master/title.png)](https://hub.docker.com/r/qmcgaw/caddy-scratch)

[![Build Status](https://travis-ci.org/qdm12/caddy-scratch.svg?branch=master)](https://travis-ci.org/qdm12/caddy-scratch)
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
| 20.5MB | MB | Depends |

It is based on:

- [Scratch](https://hub.docker.com/_/scratch/)
- [Caddy 0.11.1](https://github.com/mholt/caddy)

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

### Environment variables

| Environment variable | Default | Possible values | Description |
| --- | --- | --- | --- |
| `` | `` | `` | |

## TODOs

- [ ] Use lists of IPs to block with ipfilter with `import blockIps`
- [ ] Healthcheck for Caddy
- [ ] Fix reloading of Caddyfile with SIGUSR1
- [ ] Intelligent IP blocking

## License

This repository is under an [MIT license](https://github.com/qdm12/caddy-scratch/master/license)
