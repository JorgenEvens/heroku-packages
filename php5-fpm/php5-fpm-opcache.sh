#!/bin/sh

if [ -z "$PHP5_EXT_HELPER" ]; then
	PHP5_EXT_HELPER="true"
	download "http://jorgen.evens.eu/heroku/php5-fpm/extension-helper" "${CACHE_DIR}/php5-extension-helper.sh"
	. "${CACHE_DIR}/php5-extension-helper.sh"
fi

dependency_require "php5-fpm"
php5ext_compile "opcache"

sed -i 's/extension=opcache\.so/zend_extension=opcache\.so/g' "${BUILD_DIR}/vendor/php5-fpm/etc/php.ini"