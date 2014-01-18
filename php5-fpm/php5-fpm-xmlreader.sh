#!/bin/sh

if [ -z "$PHP5_EXT_HELPER" ]; then
	PHP5_EXT_HELPER="true"
	download "${INSTALLER_DIR}/extension-helper" "${CACHE_DIR}/php5-extension-helper.sh"
	. "${CACHE_DIR}/php5-extension-helper.sh"
fi

dependency_require "php5-fpm"
php5ext_compile "xmlreader"
