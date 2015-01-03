PHP5-FPM without any configuration applied

These configure options were used:

./configure
--prefix=/app/vendor/php5-fpm
--enable-fpm
--disable-cli
--disable-cgi
--disable-debug
--with-regex=php
--disable-rpath
--disable-static
--with-pic
--with-layout=GNU
--without-pear
--enable-calendar
--enable-sysvsem
--enable-sysvshm
--enable-sysvmsg
--enable-bcmath
--with-bz2
--with-curl=shared,/usr
--enable-ctype
--with-iconv=shared
--with-jpeg-dir=/usr
--with-png-dir=/usr
--with-freetype-dir=/usr
--with-gd=shared
--enable-exif
--enable-ftp
--with-gettext=shared
--enable-mbstring
--with-pcre-regex=/app/vendor/pcre
--with-pcre-dir=/app/vendor/pcre
--disable-shmop
--enable-sockets
--enable-wddx=shared
--with-libxml-dir=shared,/usr
--with-zlib
--without-kerberos
--with-openssl
--enable-soap=shared
--enable-zip=shared
--with-mhash=yes
--without-mm
--enable-pdo=shared
--with-pdo-mysql=shared
--disable-dba
--enable-inifile
--enable-flatfile
--with-mysql=shared
--with-mysqli=shared
--without-sybase-ct
--without-mssql
--with-sqlite3=shared
--with-pdo-sqlite=shared
--with-pgsql=shared
--enable-json=shared
--without-ldap
--with-mcrypt=shared,/app/vendor/libmcrypt
--enable-opcache=shared
--enable-session
--without-snmp
--with-tidy=shared,/app/vendor/libtidy
--enable-xml=shared
--enable-mysqlnd
--enable-shared
--enable-dom=shared
--enable-xmlreader=shared

Use following script to package up php extensions

#!/bin/sh

PHP_VERSION="5.5.2"
PHP_API="20121212"

EXT_SRC="php5-fpm/lib/php/$PHP_API"
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