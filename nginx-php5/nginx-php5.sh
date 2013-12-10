#!/bin/sh

nginxfpm_compile() {
	dependency_require "nginx"
	dependency_require "php5-fpm"

	PHPFPM_CONFIG="${BUILD_DIR}/vendor/php5-fpm/etc/php-fpm.conf"
	NGINX_CONFIG="${BUILD_DIR}/vendor/nginx/conf/nginx.conf"

	SOCKET=$(nginxfpm_find_socket "$PHPFPM_CONFIG")
	ROOT=$(nginxfpm_find_root "$NGINX_CONFIG")
	INSERT_LINE=$(nginxfpm_find_line "$NGINX_CONFIG")

	nginxfpm_install "$SOCKET" "$ROOT" "$INSERT_LINE" "$NGINX_CONFIG"
}

nginxfpm_find_socket() {
	PHPFPM_CONFIG=$1

	SOCKET=$(cat "$PHPFPM_CONFIG" | grep -P "listen\\s*=\\s*.+" | cut -d"=" -f2)
	echo $SOCKET
}

nginxfpm_find_line() {
	NGINX_CONFIG=$1

	echo $(grep -n -P "listen\\s+80;" "$NGINX_CONFIG" | cut -d":" -f1)
}

nginxfpm_find_root() {
	NGINX_CONFIG=$1

	echo $(grep -m 1 -o -P 'root\s+.+' "$NGINX_CONFIG" | grep -o -P '[^(;|\s]+;' | grep -o -P "[^;]+")
}

nginxfpm_install() {
	SOCKET=$1
	ROOT=$2
	INSERT_LINE=$3
	NGINX_CONFIG=$4
	print_action "Configuring nginx for PHP5-FPM"
	print "Socket found at ${SOCKET}"
	print "Root directory ${ROOT}"
	print "Inserting php location block at ${NGINX_CONFIG}:${INSERT_LINE}"

	sed -i "${INSERT_LINE} i\
        location ~ \.php\$ { \\
                fastcgi_index  index.php; \\
                fastcgi_param  DOCUMENT_ROOT    $ROOT; \\
                fastcgi_param  SCRIPT_FILENAME  $ROOT\$fastcgi_script_name; \\
                include fastcgi_params; \\
\\
                if ( -f \$request_filename ) { \\
                        fastcgi_pass   unix:$SOCKET; \\
                } \\
        } \
    " "$NGINX_CONFIG"

    sed -i "s/\\bindex\\s\+/index\\tindex.php /g" "$NGINX_CONFIG"
}

nginxfpm_compile
