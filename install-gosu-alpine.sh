#!/bin/sh
set -euxo pipefail

GOSU_VERSION=1.11

apk add --no-cache --virtual .gosu-deps ca-certificates dpkg gnupg

DPKG_ARCH="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
wget --output-document=/usr/local/bin/gosu \
  "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$DPKG_ARCH"
wget --output-document=/usr/local/bin/gosu.asc \
  "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$DPKG_ARCH.asc"

# verify the signature
export GNUPGHOME="$(mktemp -d)"
gpg --batch --keyserver hkps://keys.openpgp.org \
  --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
command -v gpgconf && gpgconf --kill all || :
rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc

# clean up fetch dependencies
apk del --no-network .gosu-deps

chmod +x /usr/local/bin/gosu
# verify that the binary works
gosu --version
gosu nobody true

