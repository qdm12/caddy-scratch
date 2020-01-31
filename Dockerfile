ARG ALPINE_VERSION=3.11
ARG GO_VERSION=1.13.7

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
ARG VERSION=v1.0.4
ARG PLUGINS=
ARG TELEMETRY=false
ENV GO111MODULE=on
RUN apk add -q --progress --update --no-cache git gcc musl-dev ca-certificates tzdata
RUN git clone --branch ${VERSION} --single-branch --depth 1 https://github.com/mholt/caddy /go/src/github.com/mholt/caddy > /dev/null 2>&1 && \
    git clone --single-branch --depth 1 https://github.com/caddyserver/dnsproviders /go/src/github.com/caddyserver/dnsproviders > /dev/null 2>&1
RUN go get github.com/abiosoft/caddyplug/caddyplug > /dev/null 2>&1
WORKDIR /caddy
RUN set -e; \
    for plugin in $(echo $PLUGINS | tr "," " "); do \
    if [ -f "/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" ]; then \
    PACKAGE="caddy/dnsproviders/$plugin"; \
    mkdir -p "dnsproviders/$plugin"; \
    cp -f "/go/src/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" "dnsproviders/$plugin/$plugin.go"; \
    else \
    PACKAGE=`GO111MODULE=off caddyplug package "$plugin"` 2> /dev/null; \
    fi; \
    printf "package main\nimport _ \"$PACKAGE\"" > "$plugin.go"; \
    unset -v PACKAGE; \
    done
RUN go mod init caddy > /dev/null 2>&1 && \
    go get github.com/caddyserver/caddy@${VERSION} > /dev/null 2>&1 && \
    printf "package main\nimport \"github.com/caddyserver/caddy/caddy/caddymain\"\n\nfunc main() {\n    caddymain.EnableTelemetry = $TELEMETRY\n    caddymain.Run()\n}\n" > main.go
RUN CGO_ENABLED=0 go build -a -ldflags="-s -w" > /dev/null 2>&1

FROM scratch
ARG VERSION=v1.0.4
ARG BUILD_DATE
ARG VCS_REF
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version="" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/caddy-scratch" \
    org.opencontainers.image.documentation="https://github.com/qdm12/caddy-scratch/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qdm12/caddy-scratch" \
    org.opencontainers.image.title="caddy-scratch" \
    org.opencontainers.image.description="Caddy server ${VERSION} on a Scratch base image"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
EXPOSE 8080 8443 2015
ENV HOME=/ \
    CADDYPATH=/data \
    TZ=America/Montreal
VOLUME ["/data"]
ENTRYPOINT ["/caddy"]
CMD ["-conf","/Caddyfile","-log","stdout","-agree","-http-port","8080","-https-port","8443"]
USER 1000
# see https://caddyserver.com/docs/cli
COPY --from=builder --chown=1000 /caddy/caddy /caddy
