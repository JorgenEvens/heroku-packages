#!/bin/sh

PHANTOMJS_VERSION="1.9.0-fonts"
PHANTOMJS_HOST="$INSTALLER_DIR"

phantomjs_compile() {	
	BINARIES="${CACHE_DIR}/phantomjs-${PHANTOMJS_VERSION}.tar.gz"

	phantomjs_download "${BINARIES}"
	phantomjs_install "${BINARIES}"
	phantomjs_generate_profile
}

phantomjs_download() {
	TARGET=$1
	HOST="$PHANTOMJS_HOST"
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading PhantomJS ${PHANTOMJS_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit !
	fi
}

phantomjs_install() {
	print_action "Installing PhantomJS ${PHANTOMJS_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R phantomjs 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

phantomjs_generate_profile() {
	echo "export PATH=\"\$PATH:/app/vendor/phantomjs/bin/\"" >> "${BUILD_DIR}/.profile"
}

phantomjs_compile
