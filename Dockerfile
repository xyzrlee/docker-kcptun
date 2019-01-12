#
# Dockerfile for kcptun
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk upgrade \
 && apk add --no-cache --virtual .build-deps \
      git \
      ca-certificates \
      go \
      gcc \
      musl-dev \
 && go get golang.org/x/crypto/pbkdf2 \
           github.com/xtaci/smux \
           github.com/xtaci/kcp-go \
           github.com/urfave/cli \
           github.com/pkg/errors \
           github.com/golang/snappy \
 # Build & install
 && mkdir -p /tmp/repo \
 && cd /tmp/repo \
 && git clone https://github.com/xtaci/kcptun.git \
 && cd kcptun/client \
 && go build -o ../kcptun-client \
 && cd ../server \
 && go build -o ../kcptun-server \
 && cd .. \
 && cp kcptun-server /usr/local/bin \
 && cp kcptun-client /usr/local/bin \
 && cd / \
 && rm -rf /tmp/repo \
 && rm -rf $(go env GOPATH) \
 && go clean \
 && apk del .build-deps

USER root

