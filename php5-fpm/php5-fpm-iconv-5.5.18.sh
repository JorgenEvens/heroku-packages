#!/bin/sh

PHP5EXT_VERSION="5.5.18"
PHP5EXT_MD5="0f3a49408793c9fa44960d498423a9e9"
PHP5EXT_NAME="iconv"
PHP5EXT_BIN="php5-fpm-${PHP5EXT_NAME}-${PHP5EXT_VERSION}.tar.gz"

dependency_require "php5-fpm"
dependency_require "php$PHP5EXT_VERSION"

unpack "${INSTALLER_DIR}/${PHP5EXT_BIN}" "$PHP5EXT_MD5"
php5_ext_enable "$PHP5EXT_NAME"
