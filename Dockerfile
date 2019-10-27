ARG BASE_IMAGE_BUILDER=golang
ARG ALPINE_VERSION=3.10
ARG GO_VERSION=1.13

FROM ${BASE_IMAGE_BUILDER}:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
ARG GOARCH=amd64
ARG GOARM=
ARG VERSION=v1.0.3
ARG PLUGINS=
ARG TELEMETRY=false
ENV GO111MODULE=on
RUN apk add -q --progress --update --no-cache git gcc musl-dev ca-certificates tzdata
RUN git clone --branch ${VERSION} --single-branch --depth 1 https://github.com/mholt/caddy /go/src/github.com/mholt/caddy > /dev/null 2>&1 && \
    git clone --single-branch --depth 1 https://github.com/caddyserver/dnsproviders /go/src/github.com/caddyserver/dnsproviders > /dev/null 2>&1
RUN GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go get github.com/abiosoft/caddyplug/caddyplug > /dev/null 2>&1
WORKDIR /caddy
RUN set -e; \
    for plugin in $(echo $PLUGINS | tr "," " "); do \
    if [ -f "/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" ]; then \
    PACKAGE="caddy/dnsproviders/$plugin"; \
    mkdir -p "dnsproviders/$plugin"; \
    cp -f "/go/src/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" "dnsproviders/$plugin/$plugin.go"; \
    else \
    PACKAGE=`GO111MODULE=off GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} caddyplug package "$plugin"` 2> /dev/null; \
    fi; \
    printf "package main\nimport _ \"$PACKAGE\"" > "$plugin.go"; \
    unset -v PACKAGE; \
    done
RUN go mod init caddy > /dev/null 2>&1 && \
    GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go get github.com/caddyserver/caddy@${VERSION} > /dev/null 2>&1 && \
    printf "package main\nimport \"github.com/caddyserver/caddy/caddy/caddymain\"\n\nfunc main() {\n    caddymain.EnableTelemetry = $TELEMETRY\n    caddymain.Run()\n}\n" > main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go build -a -ldflags="-s -w" > /dev/null 2>&1

FROM scratch
ARG VERSION=v1.0.3
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.schema-version="1.0.0-rc1" \
    maintainer="quentin.mcgaw@gmail.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/qdm12/caddy-scratch" \
    org.label-schema.url="https://github.com/qdm12/caddy-scratch" \
    org.label-schema.vcs-description="Caddy server 1.0.0 on a Scratch base image" \
    org.label-schema.vcs-usage="https://github.com/qdm12/caddy-scratch/blob/master/README.md#setup" \
    org.label-schema.docker.cmd="docker run -d -v $(pwd)/Caddyfile:/Caddyfile:ro -v $(pwd)/data:/data -v $(pwd)/srv:/srv:ro -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp qmcgaw/caddy-scratch" \
    org.label-schema.docker.cmd.devel="docker run -it --rm -v $(pwd)/Caddyfile:/Caddyfile:ro -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp qmcgaw/caddy-scratch" \
    org.label-schema.docker.params="" \
    org.label-schema.version="${VERSION}" \
    image-size="15.8MB" \
    ram-usage="18MB but depends on traffic" \
    cpu-usage="Low but depends on traffic"
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
