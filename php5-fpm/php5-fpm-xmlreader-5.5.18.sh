#!/bin/sh

PHP5EXT_VERSION="5.5.18"
PHP5EXT_MD5="14cafea4ce614fe6e897969158454e19"
PHP5EXT_NAME="xmlreader"
PHP5EXT_BIN="php5-fpm-${PHP5EXT_NAME}-${PHP5EXT_VERSION}.tar.gz"

dependency_require "php5-fpm"
dependency_require "php$PHP5EXT_VERSION"

unpack "${INSTALLER_DIR}/${PHP5EXT_BIN}" "$PHP5EXT_MD5"
php5_ext_enable "$PHP5EXT_NAME"
