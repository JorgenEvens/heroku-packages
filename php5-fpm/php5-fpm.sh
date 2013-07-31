#!/bin/sh

PHPFPM_VERSION="5.5.1"
PHPFPM_HOST="http://jorgen.evens.eu/heroku"

phpfpm_compile() {
	dependency_require "pcre"
	dependency_require "libtidy"
	dependency_require "libmcrypt"
	
	BINARIES="${CACHE_DIR}/php5-fpm-${PHPFPM_VERSION}.tar.gz"

	phpfpm_download "${BINARIES}"
	phpfpm_install "${BINARIES}"
	phpfpm_generate_boot
}

phpfpm_download() {
	TARGET=$1
	HOST=$PHPFPM_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading PHP5-FPM ${PHPFPM_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit !
	fi
}

phpfpm_install() {
	print_action "Installing PHP5-FPM ${PHPFPM_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R php5-fpm 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

phpfpm_generate_boot() {
	print_action "Generating boot portion for PHP5-FPM"
	echo "/app/vendor/php5-fpm/sbin/php-fpm &" >> "${BUILD_DIR}/boot.sh"
}

phpfpm_compile