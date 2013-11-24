#!/bin/sh

IMAGEMAGICK_VERSION="6.8.6"
IMAGEMAGICK_HOST="https://jorgen.evens.eu/heroku/imagemagick"
IMAGEMAGICK_MD5="bdd636924cf9ca15a65c9aa7bc5a0a35"

imagemagick_compile() {
	VERSION=$IMAGEMAGICK_VERSION
	BINARIES="${CACHE_DIR}/imagemagick-${VERSION}.tar.gz"

	imagemagick_download "$BINARIES"
	imagemagick_install "$BINARIES"
	imagemagick_generate_profile
}

imagemagick_download() {
	TARGET=$1
	HOST=$IMAGEMAGICK_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading ImageMagick ${IMAGEMAGICK_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${IMAGEMAGICK_MD5}"
}

imagemagick_install() {
	print_action "Installing ImageMagick ${IMAGEMAGICK_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract ImageMagick
	cd "${BUILD_DIR}/vendor"
	rm -R imagemagick 2> /dev/null
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

imagemagick_generate_profile() {
	print_action "Generating .profile"
	echo "export PATH=\"\$PATH:/app/vendor/imagemagick/bin\"" >> "${BUILD_DIR}/.profile"
	echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/app/vendor/imagemagick/lib\"" >> "${BUILD_DIR}/.profile"
}

imagemagick_compile
