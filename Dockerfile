ARG BASE_IMAGE_BUILDER=golang
ARG ALPINE_VERSION=3.10
ARG GO_VERSION=1.12.6

FROM ${BASE_IMAGE_BUILDER}:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
ARG GOARCH=amd64
ARG GOARM=
ARG VERSION=v1.0.0
ARG PLUGINS=
ARG TELEMETRY=false
ENV GO111MODULE=on
RUN apk add -q --progress --update git gcc musl-dev ca-certificates
RUN git clone --branch ${VERSION} --single-branch --depth 1 https://github.com/mholt/caddy /go/src/github.com/mholt/caddy 2> /dev/null && \
    git clone --single-branch --depth 1 https://github.com/caddyserver/dnsproviders /go/src/github.com/caddyserver/dnsproviders 2> /dev/null
RUN GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go get github.com/abiosoft/caddyplug/caddyplug 2> /dev/null
WORKDIR /caddy
RUN for plugin in $(echo $PLUGINS | tr "," " "); do \
    if [ -f "/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" ]; then \
    mkdir -p "dnsproviders/$plugin" && \
    cp -f "/go/src/github.com/caddyserver/dnsproviders/$plugin/$plugin.go" "dnsproviders/$plugin/$plugin.go" && \
    printf "package main\nimport _ \"caddy/dnsproviders/$plugin\"" > "$plugin.go"; \
    else \
    GO111MODULE=off GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} caddyplug package "$plugin" 2> /dev/null; \
    fi \
    done
RUN go mod init caddy && \
    GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go get github.com/mholt/caddy@${VERSION} 2> /dev/null && \
    printf "package main\nimport \"github.com/mholt/caddy/caddy/caddymain\"\n\nfunc main() {\n    caddymain.EnableTelemetry = $TELEMETRY\n    caddymain.Run()\n}\n" > main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go build -a -installsuffix cgo -ldflags="-s -w" 2> /dev/null

FROM scratch
ARG VERSION=v1.0.0
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
EXPOSE 8080 8443 2015
ENV HOME=/ \
    CADDYPATH=/data
VOLUME ["/data"]
ENTRYPOINT ["/caddy","-conf","/Caddyfile","-log","stdout"]
CMD ["-agree","-http-port","8080","-https-port","8443"]
USER 1000
# see https://caddyserver.com/docs/cli
COPY --from=builder --chown=1000 /caddy/caddy /caddy
