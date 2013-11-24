#!/bin/sh

NGINXEXTRAS1_VERSION="1.4.2"
NGINXEXTRAS1_HOST="http://jorgen.evens.eu/heroku/nginx"
NGINXEXTRAS1_MD5="7d0def57f94d893061aa945c7c53b008"

nginxextras1_compile() {
	dependency_require "pcre"

	VERSION=$NGINXEXTRAS1_VERSION
	BINARIES="${CACHE_DIR}/nginx-extras1-${VERSION}.tar.gz"

	nginxextras1_download "$BINARIES"
	nginxextras1_install "$BINARIES"
	nginxextras1_generate_boot
}

nginxextras1_download() {
	TARGET=$1
	HOST=$NGINXEXTRAS1_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading Nginx with rtmp ${NGINXEXTRAS1_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${NGINXEXTRAS1_MD5}"
}

nginxextras1_install() {
	print_action "Installing Nginx with rtmp ${NGINXEXTRAS1_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract Nginx
	cd "${BUILD_DIR}/vendor"
	rm -R nginx 2> /dev/null
	tar -xf "${BINARIES}"

	# Disabled daemonization
	NGINXEXTRAS1_CONF="${BUILD_DIR}/vendor/nginx/conf/nginx.conf"
	mv "${NGINXEXTRAS1_CONF}" "${NGINXEXTRAS1_CONF}.orig"
	echo "daemon off;" > "${NGINXEXTRAS1_CONF}"
	cat "${NGINXEXTRAS1_CONF}.orig" >> "${NGINXEXTRAS1_CONF}"
	rm "${NGINXEXTRAS1_CONF}.orig"

	sed -i "s/root\s\+[^;]\+/root \/app\/src/g" "${NGINXEXTRAS1_CONF}"

	# Return to original directory
	cd "$CUR_DIR"
}

nginxextras1_generate_boot() {
	print_action "Generating boot portion for nginx-extras1"
	echo 'sed -i "s/listen\s\+80;/listen $PORT;/g" "/app/vendor/nginx/conf/nginx.conf"' >> "${BUILD_DIR}/boot.sh"
	echo "/app/vendor/nginx/sbin/nginx &" >> "${BUILD_DIR}/boot.sh"
}

nginxextras1_compile
dependency_mark "nginx"