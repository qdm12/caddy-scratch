ARG ALPINE_VERSION=3.8
ARG GO_VERSION=1.11.4

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
ARG PLUGINS=minify,ipfilter,nobots,ratelimit
# Extra plugins: realip,forwardproxy
ARG TELEMETRY=false
RUN apk add --progress --update git gcc musl-dev ca-certificates
WORKDIR /go/src/github.com/mholt/caddy
RUN git clone --branch v0.11.1 --single-branch --depth 1 https://github.com/mholt/caddy /go/src/github.com/mholt/caddy && \
    $TELEMETRY || sed -i 's/var EnableTelemetry = true/var EnableTelemetry = false/' /go/src/github.com/mholt/caddy/caddy/caddymain/run.go
RUN git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds
RUN GOOS=linux GOARCH=amd64 go get -v github.com/abiosoft/caddyplug/caddyplug
RUN for plugin in $(echo $PLUGINS | tr "," " "); do \
      go get -v $(GOOS=linux GOARCH=amd64 caddyplug package $plugin) && \
      printf "package caddyhttp\nimport _ \"$(GOOS=linux GOARCH=amd64 caddyplug package $plugin)\"" > /go/src/github.com/mholt/caddy/caddyhttp/$plugin.go; \
    done
RUN cd caddy && \
    go run build.go -goos=linux -goarch=amd64

FROM alpine:${ALPINE_VERSION} AS alpine
RUN apk --update add ca-certificates

FROM scratch
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="quentin.mcgaw@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/qdm12/caddy-scratch" \
      org.label-schema.url="https://github.com/qdm12/caddy-scratch" \
      org.label-schema.vcs-description="Caddy server on a Scratch base image" \
      org.label-schema.vcs-usage="https://github.com/qdm12/caddy-scratch/blob/master/README.md#setup" \
      org.label-schema.docker.cmd="docker run -d -v $(pwd)/Caddyfile:/Caddyfile:ro -v $(pwd)/data:/data -v $(pwd)/srv:/srv:ro -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp qmcgaw/caddy-scratch" \
      org.label-schema.docker.cmd.devel="docker run -it --rm -v $(pwd)/Caddyfile:/Caddyfile:ro -p 80:8080/tcp -p 443:8443/tcp -p 2015:2015/tcp qmcgaw/caddy-scratch" \
      org.label-schema.docker.params="" \
      org.label-schema.version="" \
      image-size="20.5MB" \
      ram-usage="MB" \
      cpu-usage="Depends"
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
EXPOSE 8080 8443 2015
# HEALTHCHECK --interval=100s --timeout=3s --start-period=10s --retries=1 CMD ["/healthcheck"]   
ENV HOME=/ \
    CADDYPATH=/data
VOLUME ["/data"]
USER 1000
ENTRYPOINT ["/caddy","-conf","/Caddyfile","-log","stdout","-agree"]
CMD ["-http-port","8080","-https-port","8443"]
# see https://caddyserver.com/docs/cli
COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /caddy
