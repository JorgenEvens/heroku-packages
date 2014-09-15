#!/bin/sh

NODEJS_VERSION="0.10.28"
NODEJS_HOST="$INSTALLER_DIR"
NODEJS_MD5="abf6b099f2d7a36526eecc2f8c8d6027"

nodejs_compile() {
	VERSION=$NODEJS_VERSION
	BINARIES="${CACHE_DIR}/nodejs-${VERSION}.tar.gz"

	nodejs_download "$BINARIES"
	nodejs_install "$BINARIES"
	nodejs_generate_profile
}

nodejs_download() {
	TARGET=$1
	HOST=$NODEJS_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading NodeJS ${NODEJS_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${NODEJS_MD5}"
}

nodejs_install() {
	print_action "Installing NodeJS ${NODEJS_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract NodeJS
	cd "${BUILD_DIR}/vendor"
	rm -R nodejs 2> /dev/null
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

nodejs_generate_profile() {
	print_action "Generating .profile"
	echo "export PATH=\"\$PATH:/app/vendor/nodejs/bin\"" >> "${BUILD_DIR}/.profile"
	
}

nodejs_compile
