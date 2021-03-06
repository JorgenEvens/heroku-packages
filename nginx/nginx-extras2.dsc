Provides an unconfigured NGINX server with some extra modules.

export LUAJIT_LIB="/app/vendor/luajit/lib"
export LUAJIT_INC="/app/vendor/luajit/include/luajit-2.0"

./configure
--with-pcre=/app/pcre-8.33
--prefix=/app/vendor/nginx
--with-select_module
--with-http_gzip_static_module
--with-http_geoip_module
--with-http_secure_link_module
--without-poll_module
--without-http_ssi_module
--without-http_userid_module
--without-http_access_module
--without-http_autoindex_module
--without-http_map_module
--without-http_split_clients_module
--without-http_proxy_module
--without-http_uwsgi_module
--without-http_scgi_module
--without-http_memcached_module
--without-http_limit_conn_module
--without-http_limit_req_module
--without-mail_pop3_module
--without-mail_imap_module
--without-mail_smtp_module
--add-module=/app/ngx_devel_kit-0.2.19
--add-module=/app/ngx_cache_purge-2.1
--add-module=/app/nginx-static-etags
--add-module=/app/xss-nginx-module
--add-module=/app/lua-nginx-module-0.9.4
--add-module=/app/redis2-nginx-module-0.10
--add-module=/app/nginx-push-stream-module
--add-module=/app/set-misc-nginx-module-0.24
--with-cc-opt="-I/app/vendor/geoip/include"
--with-ld-opt="-L/app/vendor/geoip/lib"