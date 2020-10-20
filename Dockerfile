FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
  apk --no-cache add caddy tzdata curl ca-certificates
  
RUN \
	adduser -u 82 -D -S -G www-data -g www www && \
	mkdir -p /var/www /run/caddy /etc/caddy/ssl && \
	chown -R www:www-data /var/www && \
	chown -R www:www-data /run/caddy
	
RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /etc/periodic/monthly/geoip && \
	rm -f /var/cache/apk/*

VOLUME ["/var/www"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 80 443

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["caddy", "-conf", "/etc/caddy/caddy.conf", "-disable-http-challenge", "-disable-tls-alpn-challenge", "-pidfile", "/run/caddy"]
