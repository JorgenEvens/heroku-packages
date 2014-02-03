#!/bin/sh

NGINXEXTRAS2_VERSION="1.4.4-extras2"
NGINXEXTRAS2_HOST="$INSTALLER_DIR"
NGINXEXTRAS2_MD5="0435c25d7a95f2d4f236fb94f2473a5f"

nginxextras2_compile() {
	dependency_require "pcre"
	dependency_require "geoip"
	dependency_require "luajit"

	VERSION=$NGINXEXTRAS2_VERSION
	BINARIES="${CACHE_DIR}/nginx-${VERSION}.tar.gz"

	nginxextras2_download "$BINARIES"
	nginxextras2_install "$BINARIES"
	nginxextras2_generate_boot
}

nginxextras2_download() {
	TARGET=$1
	HOST=$NGINXEXTRAS2_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Downloading Nginx ${NGINXEXTRAS2_VERSION} from ${URL} to ${TARGET}"
	cached_download "$URL" "$TARGET" "${NGINXEXTRAS2_MD5}"
}

nginxextras2_install() {
	print_action "Installing Nginx ${NGINXEXTRAS2_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract Nginx
	cd "${BUILD_DIR}/vendor"
	rm -R nginx 2> /dev/null
	tar -xf "${BINARIES}"

	# Disabled daemonization
	NGINXEXTRAS2_CONF="${BUILD_DIR}/vendor/nginx/conf/nginx.conf"
	mv "${NGINXEXTRAS2_CONF}" "${NGINXEXTRAS2_CONF}.orig"
	echo "daemon off;" > "${NGINXEXTRAS2_CONF}"
	cat "${NGINXEXTRAS2_CONF}.orig" >> "${NGINXEXTRAS2_CONF}"
	rm "${NGINXEXTRAS2_CONF}.orig"

	sed -i "s/root\s\+[^;]\+/root \/app\/src/g" "${NGINXEXTRAS2_CONF}"

	# Return to original directory
	cd "$CUR_DIR"
}

nginxextras2_generate_boot() {
	print_action "Generating boot portion for nginx-extras1"
	echo 'sed -i "s/listen\s\+80;/listen $PORT;/g" "/app/vendor/nginx/conf/nginx.conf"' >> "${BUILD_DIR}/boot.sh"
	echo "/app/vendor/nginx/sbin/nginx &" >> "${BUILD_DIR}/boot.sh"
}

nginxextras2_compile
dependency_mark "nginx"
