#!/bin/sh

FFMPEG_VERSION="2.0"
FFMPEG_HOST="http://jorgen.evens.eu/heroku/ffmpeg"

ffmpeg_compile() {	
	BINARIES="${CACHE_DIR}/ffmpeg-${FFMPEG_VERSION}.tar.gz"

	ffmpeg_download "${BINARIES}"
	ffmpeg_install "${BINARIES}"
	ffmpeg_generate_profile
}

ffmpeg_download() {
	TARGET=$1
	HOST=$FFMPEG_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading FFmpeg ${FFMPEG_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit !
	fi
}

ffmpeg_install() {
	print_action "Installing FFmpeg ${FFMPEG_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R ffmpeg 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

ffmpeg_generate_profile() {
	echo "export PATH=\"\$PATH:/app/vendor/ffmpeg/bin\"" >> "${BUILD_DIR}/.profile"
	echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/app/vendor/ffmpeg/lib\"" >> "${BUILD_DIR}/.profile"
}

ffmpeg_compile
