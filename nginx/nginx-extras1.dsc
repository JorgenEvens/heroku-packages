Provides an unconfigured NGINX server with some extra modules.

ngx_cache_purge
nginx-rtmp-module
nginx-static-etags
xss-nginx-module

./configure
--with-pcre=/app/pcre-8.33
--prefix=/app/vendor/nginx
--with-select_module
--without-poll_module
--with-http_gzip_static_module
--without-http_ssi_module
--without-http_userid_module
--without-http_access_module
--without-http_autoindex_module
--without-http_geo_module
--without-http_map_module
--without-http_split_clients_module
--without-http_proxy_module
--without-http_uwsgi_module
--without-http_scgi_module
--without-http_memcached_module
--without-http_limit_conn_module
--without-http_limit_req_module
--without-http_empty_gif_module
--without-mail_pop3_module
--without-mail_imap_module
--without-mail_smtp_module
--add-module=/app/ngx_cache_purge-2.1
--add-module=/app/nginx-rtmp-module
--add-module=/app/nginx-static-etags
--add-module=/app/xss-nginx-module