ARG ALPINE_VERSION=3.11
ARG GO_VERSION=1.14

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk add -q --progress --update --no-cache git musl-dev gcc ca-certificates tzdata
RUN mkdir -p /caddydir/data && \
    chmod -R 700 /caddydir
ENV GO111MODULE=on \
    CGO_ENABLED=0
RUN go get github.com/caddyserver/xcaddy/cmd/xcaddy@master
ARG CADDY_VERSION=v2.0.0
WORKDIR /caddy
ARG PLUGINS=
RUN for plugin in $(echo $PLUGINS | tr "," " "); do withFlags="$withFlags --with $plugin"; done && \
    xcaddy build ${CADDY_VERSION} ${withFlags}

FROM scratch
ARG VERSION
ARG CADDY_VERSION
ARG BUILD_DATE
ARG VCS_REF
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/caddy-scratch" \
    org.opencontainers.image.documentation="https://github.com/qdm12/caddy-scratch/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qdm12/caddy-scratch" \
    org.opencontainers.image.title="caddy-scratch" \
    org.opencontainers.image.description="Caddy server ${CADDY_VERSION} on Alpine"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
EXPOSE 8080 8443 2015
ENV HOME=/caddydir \
    CADDYPATH=/caddydir/data \
    TZ=America/Montreal
COPY --from=builder --chown=1000 /caddydir /caddydir
VOLUME ["/caddydir"]
ENTRYPOINT ["/caddy"]
USER 1000
# see https://caddyserver.com/docs/cli
CMD ["run","--config","/caddydir/Caddyfile"]
COPY --chown=1000 Caddyfile /caddydir/Caddyfile
COPY --from=builder --chown=1000 /caddy/caddy /caddy
