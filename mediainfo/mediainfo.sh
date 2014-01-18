#!/bin/sh

MEDIAINFO_VERSION="0.7.64"
MEDIAINFO_HOST="$INSTALLER_DIR"
MEDIAINFO_MD5="bbe753a2ac3d43254be5abd0c62bd2fb"

mediainfo_compile() {
	VERSION=$MEDIAINFO_VERSION
	BINARIES="${CACHE_DIR}/mediainfo-${VERSION}.tar.gz"

	mediainfo_download "$BINARIES"
	mediainfo_install "$BINARIES"
	mediainfo_generate_profile
}

mediainfo_download() {
	TARGET=$1
	HOST=$MEDIAINFO_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading MediaInfo ${MEDIAINFO_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${MEDIAINFO_MD5}"
}

mediainfo_install() {
	print_action "Installing MediaInfo ${MEDIAINFO_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract MediaInfo
	cd "${BUILD_DIR}/vendor"
	rm -R mediainfo 2> /dev/null
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

mediainfo_generate_profile() {
	print_action "Generating .profile"
	echo "export PATH=\"\$PATH:/app/vendor/mediainfo\"" >> "${BUILD_DIR}/.profile"
}

mediainfo_compile
