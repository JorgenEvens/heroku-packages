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

use following snippet to generate .tar.gz archives from the files in extensions

for line in `ls extensions | grep -o '[^\.]\+\.' | sort | uniq | tr -d '.'`; do
cp -R ext-base ${line}
cp extensions/${line}.* ${line}/lib/php/20121212
mkdir tmp 2> /dev/null
mv ${line} tmp/
cd tmp
mv ${line} php5-fpm
tar -caf php5-fpm-${line}-5.5.1.tar.gz php5-fpm
mv *.tar.gz ..
cd ..
rm -R tmp
done;

use following snippet to generate shell scripts from tar.gz extensions

for line in `ls *.tar.gz | cut -d"-" -f3`; do
sed "s/ext_placeholder/$line/g" extension_placeholder > php5-fpm-$line.sh
done