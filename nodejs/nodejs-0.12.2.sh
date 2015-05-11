#!/bin/sh

NODEJS_VERSION="0.12.2"
NODEJS_HOST="$INSTALLER_DIR"
NODEJS_MD5="1c90cb34f5f5065a79a601e73037d891"

unpack "${HOST}/nodejs-${NODEJS_VERSION}.tar.gz" $NODEJS_MD5

print_action "Generating .profile"
echo 'export PATH="$PATH:/app/vendor/nodejs/bin"' >> "${BUILD_DIR}/.profile"
