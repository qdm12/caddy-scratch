ARG BASE_IMAGE_BUILDER=golang
ARG BASE_IMAGE=alpine
ARG ALPINE_VERSION=3.9
ARG GO_VERSION=1.12.5

FROM ${BASE_IMAGE_BUILDER}:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
ARG GOARCH=amd64
ARG GOARM=
ARG VERSION=v1.0.0
ARG PLUGINS=
ARG TELEMETRY=false
RUN apk add --progress --update git gcc musl-dev ca-certificates
WORKDIR /go/src/github.com/mholt/caddy
RUN git clone --branch ${VERSION} --single-branch --depth 1 https://github.com/mholt/caddy /go/src/github.com/mholt/caddy && \
    $TELEMETRY || sed -i 's/var EnableTelemetry = true/var EnableTelemetry = false/' /go/src/github.com/mholt/caddy/caddy/caddymain/run.go
RUN GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go get -v github.com/abiosoft/caddyplug/caddyplug
ENV GO111MODULE=on
RUN mkdir /plugins && \
    for plugin in $(echo $PLUGINS | tr "," " "); do \
    printf "package main\nimport _ \"$(GO111MODULE=off GOOS=linux GOARCH=amd64 caddyplug package $plugin)\"" > /plugins/$plugin.go; \
    done
WORKDIR /caddy
RUN go mod init caddy
RUN go get -v github.com/mholt/caddy@${VERSION}
RUN cp -r /plugins/. .
COPY main.go .
RUN go test -v ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} go build -a -installsuffix cgo -ldflags="-s -w" -o caddy

FROM alpine:${ALPINE_VERSION} AS alpine
RUN apk --update add ca-certificates

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
COPY --from=builder /caddy/caddy /caddy
