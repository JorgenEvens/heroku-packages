#!/bin/sh

PCRE_VERSION="8.33"
PCRE_HOST="http://jorgen.evens.eu/heroku/pcre"

pcre_compile() {
	BINARIES="${CACHE_DIR}/pcre-${PCRE_VERSION}.tar.gz"

	pcre_download "${BINARIES}"
	pcre_install "${BINARIES}"
	pcre_generate_boot
}

pcre_download() {
	TARGET=$1
	HOST=$PCRE_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading libpcre ${PCRE_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit 1
	fi
}

pcre_install() {
	print_action "Installing libpcre ${PCRE_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R pcre 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

pcre_generate_boot() {
	echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/app/vendor/pcre/lib\"" >> "${BUILD_DIR}/boot.sh"
}

pcre_compile