#!/bin/sh

NEWRELIC_VERSION="2.5.27"
NEWRELIC_HOST="$INSTALLER_DIR"
NEWRELIC_MD5="9b8de8c2319be0abcb1fcdfb5bc036d1"

newrelic_compile() {
	dependency_require "php5-fpm"

	VERSION=$NEWRELIC_VERSION
	BINARIES="${CACHE_DIR}/newrelic-php5-${VERSION}.tar.gz"

	newrelic_download "$BINARIES"
	newrelic_install "$BINARIES"
	newrelic_configure
}

newrelic_download() {
	TARGET=$1
	HOST=$NEWRELIC_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading New Relic ${NEWRELIC_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${NEWRELIC_MD5}"
}

newrelic_install() {
	print_action "Installing New Relic ${NEWRELIC_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract New Relic
	cd "${BUILD_DIR}/vendor"
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

newrelic_configure() {
	print_action "Installing PHP module"

	PHPPATH="${BUILD_DIR}/vendor/php5-fpm"
	ln -s "/app/vendor/newrelic/newrelic-20121212.so" "${PHPPATH}/lib/php/20121212/newrelic.so"

	cat >> "${PHPPATH}/etc/php.ini" << EOF
extension=newrelic.so
[newrelic]
newrelic.daemon.location = "/app/vendor/newrelic/daemon"
newrelic.logfile = "/app/apache/logs/error_log"
newrelic.daemon.logfile = "/app/vendor/newrelic/error_log"
newrelic.daemon.port = "/app/vendor/newrelic/.newrelic.sock"
EOF

	cat >> "${BUILD_DIR}/configure.sh" << EOF
echo "newrelic.license = \"\$NEWRELIC_LICENSE\"" >> "/app/vendor/php5-fpm/etc/php.ini"
EOF
	
}

newrelic_compile
