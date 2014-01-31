#!/bin/sh

LUAJIT_VERSION="2.0.2"
LUAJIT_HOST="$INSTALLER_DIR"

luajit_compile() {
	VERSION=$LUAJIT_VERSION
	BINARIES="${CACHE_DIR}/luajit-${VERSION}.tar.gz"

	luajit_download "$BINARIES"
	luajit_install "$BINARIES"
	luajit_generate_boot
}

luajit_download() {
	TARGET=$1
	HOST=$LUAJIT_HOST
	URL="${HOST}/$(basename $TARGET)"

	print_action "Checking cache for $TARGET."
	if [ ! -f "$TARGET" ]; then
		print_action "Downloading LuaJIT ${LUAJIT_VERSION} from ${URL} to ${TARGET}"
		download "$URL" "$TARGET"
	fi
	if [ ! -f "$TARGET" ]; then
		print "Unable to download the package"
		exit 1
	fi
}

luajit_install() {
	print_action "Installing LuaJIT ${LUAJIT_VERSION} to ${BUILD_DIR}/vendor"

	mkdir -p "${BUILD_DIR}/vendor"

	CUR_DIR=`pwd`

	# Extract Nginx
	cd "${BUILD_DIR}/vendor"
	rm -R luajit 2> /dev/null
	tar -xf "${BINARIES}"

	# Return to original directory
	cd "$CUR_DIR"
}

luajit_generate_boot() {
	print_action "Generating environment variables"
	echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/app/vendor/luajit/lib' >> "${BUILD_DIR}/.profile"
	echo 'export PATH="$PATH:/app/vendor/luajit/bin"' >> "${BUILD_DIR}/.profile"
}

luajit_compile
