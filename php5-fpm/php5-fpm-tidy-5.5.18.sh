#!/bin/sh

PHP5EXT_VERSION="5.5.18"
PHP5EXT_MD5="a10626684d8c644714a60f65c9d41bdf"
PHP5EXT_NAME="tidy"
PHP5EXT_BIN="php5-fpm-${PHP5EXT_NAME}-${PHP5EXT_VERSION}.tar.gz"

dependency_require "php5-fpm"
dependency_require "php$PHP5EXT_VERSION"

unpack "${INSTALLER_DIR}/${PHP5EXT_BIN}" "$PHP5EXT_MD5"
php5_ext_enable "$PHP5EXT_NAME"
