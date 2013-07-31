#!/bin/sh

LIBMCRYPT_VERSION="0.99"
LIBMCRYPT_HOST="http://jorgen.evens.eu/heroku"

libmcrypt_compile() {
	BINARIES="${CACHE_DIR}/libmcrypt-${LIBMCRYPT_VERSION}.tar.gz"

	libmcrypt_download "${BINARIES}"
	libmcrypt_install "${BINARIES}"
	libmcrypt_generate_boot
}

libmcrypt_download() {
	TARGET=$1
	HOST=$LIBMCRYPT_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading libmcrypt ${LIBMCRYPT_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit 1
	fi
}

libmcrypt_install() {
	print_action "Installing libmcrypt ${LIBMCRYPT_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R libmcrypt 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

libmcrypt_generate_boot() {
	echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/app/vendor/libmcrypt/lib\"" >> "${BUILD_DIR}/boot.sh"
}

libmcrypt_compile