#!/bin/sh

GEOIP_VERSION="1.4.8"
GEOIP_HOST="$INSTALLER_DIR"

geoip_compile() {
	VERSION=$GEOIP_VERSION
	BINARIES="${CACHE_DIR}/geoip-${VERSION}.tar.gz"

	geoip_download "$BINARIES"
	geoip_install "$BINARIES"
	geoip_generate_boot
}

geoip_download() {
	TARGET=$1
	HOST=$GEOIP_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET."
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading LuaJIT ${GEOIP_VERSION} from ${URL} to ${TARGET}"
		download "$URL" "$TARGET"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit 1
	fi
}

geoip_install() {
	print_action "Installing GeoIP ${GEOIP_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract Nginx
	cd "${BUILD_DIR}/vendor"
	rm -R geoip 2> /dev/null
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

geoip_generate_boot() {
	print_action "Generating environment variables"
	echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/app/vendor/geoip/lib"' >> "${BUILD_DIR}/.profile"
	echo 'export PATH="$PATH:/app/vendor/geoip/bin"' >> "${BUILD_DIR}/.profile"
}

geoip_compile
