#!/bin/sh

PHPFPM_VERSION="5.5.18"
PHPFPM_MD5="ee5b3d5be673cc071b99a389872f43d2"
PHPFPM_BIN="php5-fpm-${PHPFPM_VERSION}.tar.gz"

dependency_require "pcre"
dependency_require "libtidy"
dependency_require "libmcrypt"

unpack "${INSTALLER_DIR}/${PHPFPM_BIN}" "$PHPFPM_MD5"

print_action "Generating boot portion for PHP5-FPM"
echo "/app/vendor/php5-fpm/sbin/php-fpm &" >> "${BUILD_DIR}/boot.sh"

dependency_mark "php$PHPFPM_VERSION"
dependency_mark "php5-fpm"

php5_ext_enable() {
	local config
	local extension
	local ext_type

	extension="$1"
	ext_type="$2"

	config="${BUILD_DIR}/vendor/php5-fpm/etc/php.ini"

	if [ ! -f "$config" ]; then 
		echo "[PHP]" >> "$config"
	fi
	echo "${ext_type}extension=${extension}.so" >> "$config"
}
