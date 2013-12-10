#!/bin/sh

LIBTIDY_VERSION="0.99"
LIBTIDY_HOST="http://jorgen.evens.eu/heroku/libtidy"

libtidy_compile() {
	BINARIES="${CACHE_DIR}/libtidy-${LIBTIDY_VERSION}.tar.gz"

	libtidy_download "${BINARIES}"
	libtidy_install "${BINARIES}"
	libtidy_generate_boot
}

libtidy_download() {
	TARGET=$1
	HOST=$LIBTIDY_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading libtidy ${LIBTIDY_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit 1
	fi
}

libtidy_install() {
	print_action "Installing libtidy ${LIBTIDY_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R libtidy 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

libtidy_generate_boot() {
	echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/app/vendor/libtidy/lib\"" >> "${BUILD_DIR}/boot.sh"
}

libtidy_compile
