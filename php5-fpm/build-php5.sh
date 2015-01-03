#!/bin/sh
 
set -e

# Generates php-fpm and php-cli packages and php extension packages
# for use with the heroku modular buildpack
# https://github.com/JorgenEvens/heroku-modular-buildpack
 
### Configuration ###
PHP_VERSION="5.5.18"
PHP_API="20121212"
PHP_URL="http://be2.php.net/distributions/php-${PHP_VERSION}.tar.bz2"
 
### SCRIPT ###
### Do not edit below ###
 
# Download required libraries
mkdir vendor
cd vendor

curl http://jorgen.evens.eu/heroku/libtidy/libtidy-0.99.tar.gz | tar -xz
 
curl http://jorgen.evens.eu/heroku/libmcrypt/libmcrypt-2.5.8.tar.gz | tar -xz
 
curl http://jorgen.evens.eu/heroku/pcre/pcre-8.33.tar.gz | tar -xz
 
# Set environment variables for LD
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/app/vendor/libtidy/lib:/app/vendor/libmcrypt/lib:/app/vendor/pcre/lib"
 
# Download PHP Source
cd /app
curl $PHP_URL | tar -xj
cd php-*
 
# Configure PHP Source
./configure --prefix=/app/vendor/php5-fpm --enable-fpm --disable-cli --disable-cgi --disable-debug --with-regex=php --disable-rpath --disable-static --with-pic --with-layout=GNU --without-pear --enable-calendar --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-bcmath --with-bz2 --with-curl=shared,/usr --enable-ctype --with-iconv=shared --with-jpeg-dir=/usr --with-png-dir=/usr --with-freetype-dir=/usr --with-gd=shared --enable-exif --enable-ftp --with-gettext=shared --enable-mbstring --with-pcre-regex=/app/vendor/pcre --with-pcre-dir=/app/vendor/pcre --disable-shmop --enable-sockets --enable-wddx=shared --with-libxml-dir=shared,/usr --with-zlib --without-kerberos --with-openssl --enable-soap=shared --enable-zip=shared --with-mhash=yes --without-mm --enable-pdo=shared --with-pdo-mysql=shared --disable-dba --enable-inifile --enable-flatfile --with-mysql=shared --with-mysqli=shared --without-sybase-ct --without-mssql --with-sqlite3=shared --with-pdo-sqlite=shared --with-pgsql=shared --enable-json=shared --without-ldap --with-mcrypt=shared,/app/vendor/libmcrypt --enable-opcache=shared --enable-session --without-snmp --with-tidy=shared,/app/vendor/libtidy --enable-xml=shared --enable-mysqlnd --enable-shared --enable-dom=shared --enable-xmlreader=shared
 
# Make and install
make -j2
make install
 
# Move extensions to separate folder
cd /app/vendor/
mkdir extensions
mv php5-fpm/lib/php/20121212/* extensions
 
# Compress build of PHP5-fpm without extensions
tar -caf php5-fpm-${PHP_VERSION}.tar.gz php5-fpm
MD5=$(md5sum php5-fpm-${PHP_VERSION}.tar.gz | cut -d" " -f1)

cat > php5-fpm-${PHP_VERSION}.sh << EOF
#!/bin/sh

PHPFPM_VERSION="${PHP_VERSION}"
PHPFPM_MD5="${MD5}"
PHPFPM_BIN="php5-fpm-\${PHPFPM_VERSION}.tar.gz"

dependency_require "pcre"
dependency_require "libtidy"
dependency_require "libmcrypt"

unpack "\${INSTALLER_DIR}/\${PHPFPM_BIN}" "\$PHPFPM_MD5"

print_action "Generating boot portion for PHP5-FPM"
echo "/app/vendor/php5-fpm/sbin/php-fpm &" >> "\${BUILD_DIR}/boot.sh"

dependency_mark "php\$PHPFPM_VERSION"

php5_ext_enable() {
	local config
	local extension
	local ext_type

	extension="\$1"
	ext_type="\$2"

	config="\${BUILD_DIR}/vendor/php5-fpm/etc/php.ini"

	if [ ! -f "\$config" ]; then 
		echo "[PHP]" >> "\$config"
	fi
	echo "\${ext_type}extension=\${extension}.so" >> "\$config"
}
EOF

# Extension packaging below

EXT_SRC="extensions"
EXT_DIR="lib/php/$PHP_API"
WORK_DIR="tmp/php5-fpm"
CUR_DIR="`pwd`"

for pkg in `ls $EXT_SRC | grep -o '[^\.]\+\.' | sort | uniq | tr -d '.'`; do
	echo "Packaging ${pkg}"

	package="php5-fpm-${pkg}-${PHP_VERSION}"

	mkdir -p "${WORK_DIR}/${EXT_DIR}"
	cp $EXT_SRC/${pkg}.* "${WORK_DIR}/${EXT_DIR}"

	cd "`dirname ${WORK_DIR}`"
	tar -c php5-fpm | gzip > "${package}.tar.gz"

	mv "${package}.tar.gz" "$CUR_DIR"
	cd "$CUR_DIR"

	MD5=$(md5sum ${package}.tar.gz | cut -d" " -f1)

	cat > "${package}.sh" << EOF
#!/bin/sh

PHP5EXT_VERSION="$PHP_VERSION"
PHP5EXT_MD5="$MD5"
PHP5EXT_NAME="${pkg}"
PHP5EXT_BIN="php5-fpm-\${PHP5EXT_NAME}-\${PHP5EXT_VERSION}.tar.gz"

dependency_require "php5-fpm"
dependency_require "php\$PHP5EXT_VERSION"

unpack "\${INSTALLER_DIR}/\${PHP5EXT_BIN}" "\$PHP5EXT_MD5"
php5_ext_enable "\$PHP5EXT_NAME"
EOF

	rm -Rf ${WORK_DIR}
done
 
# Compress everything into one archive
tar -caf php5-fpm-build.tar.gz php5-fpm-*.tar.gz php5-fpm-*.sh
mv php5-fpm-build.tar.gz /app
cd /app
rm -R vendor