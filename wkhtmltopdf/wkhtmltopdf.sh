#!/bin/sh

WKHTMLTOPDF_VERSION="0.10.0.rc2"
WKHTMLTOPDF_HOST="http://jorgen.evens.eu/heroku/wkhtmltopdf"

wkhtmltopdf_compile() {	
	BINARIES="${CACHE_DIR}/wkhtmltopdf-${WKHTMLTOPDF_VERSION}.tar.gz"

	wkhtmltopdf_download "${BINARIES}"
	wkhtmltopdf_install "${BINARIES}"
	wkhtmltopdf_generate_profile
}

wkhtmltopdf_download() {
	TARGET=$1
	HOST=$WKHTMLTOPDF_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET"
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading WKHTMLToPDF ${WKHTMLTOPDF_VERSION} from ${URL} to ${TARGET}"
		download "${URL}" "${TARGET}"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit !
	fi
}

wkhtmltopdf_install() {
	print_action "Installing WKHTMLToPDF ${WKHTMLTOPDF_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	cd "${BUILD_DIR}/vendor"
	rm -R wkhtmltopdf 2> /dev/null

	tar -xf "${BINARIES}"

	cd "${CUR_DIR}"
}

wkhtmltopdf_generate_profile() {
	echo "export PATH=\"\$PATH:/app/vendor/wkhtmltopdf\"" >> "${BUILD_DIR}/.profile"
}

wkhtmltopdf_compile
