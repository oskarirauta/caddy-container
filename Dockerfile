FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --no-cache --update add sudo busybox-suid

RUN \
	addgroup -g 82 -S www-data && \
	adduser -u 82 -D -S -h /etc/caddy -G www-data -g www www

RUN \
	echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
	echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	rm -f /var/cache/apk/* && \
	apk --no-cache update && \
	apk --no-cache add caddy tzdata curl ca-certificates && \
	echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main" > /etc/apk/repositories && \
	echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community" >> /etc/apk/repositories && \
	rm -f /var/cache/apk/* && \
	apk --no-cache update

RUN \
	mkdir -p /var/htdocs /etc/caddy/ssl /var/htdocs && \
	chown -R www:www-data /etc/caddy && \
	chown -R www:www-data /var/htdocs

RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /etc/periodic/monthly/geoip && \
	rm -f /var/cache/apk/*

COPY caddy.sh /usr/sbin/caddy.sh
COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/var/htdocs"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 80 443 2019

STOPSIGNAL SIGTERM

HEALTHCHECK --interval=55s --timeout=10s --start-period=120s CMD curl -s http://127.0.0.1:2019/

ENTRYPOINT ["/scripts/entrypoint.sh"]

CMD ["caddy.sh", "run", "--config", "/etc/caddy/Caddyfile"]
