#!/bin/sh

NODEJS_VERSION="0.10.28"
NODEJS_HOST="$INSTALLER_DIR"
NODEJS_MD5="abf6b099f2d7a36526eecc2f8c8d6027"

unpack "${HOST}/nodejs-${NODEJS_VERSION}.tar.gz" $NODEJS_MD5

print_action "Generating .profile"
echo 'export PATH="$PATH:/app/vendor/nodejs/bin"' >> "${BUILD_DIR}/.profile"
