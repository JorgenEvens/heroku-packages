#!/bin/sh

PHP5EXT_VERSION="5.5.18"
PHP5EXT_MD5="c66d27db812b1b649762f0f6f14493e8"
PHP5EXT_NAME="zip"
PHP5EXT_BIN="php5-fpm-${PHP5EXT_NAME}-${PHP5EXT_VERSION}.tar.gz"

dependency_require "php5-fpm"
dependency_require "php$PHP5EXT_VERSION"

unpack "${INSTALLER_DIR}/${PHP5EXT_BIN}" "$PHP5EXT_MD5"
php5_ext_enable "$PHP5EXT_NAME"
