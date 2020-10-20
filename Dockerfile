FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --no-cache add sudo

RUN \
	addgroup -g 82 -S www-data && \
	adduser -u 82 -D -S -G www-data -g www www

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
	mkdir -p /var/www /run/caddy /etc/caddy/ssl && \
	chown -R www:www-data /var/www /run/caddy /etc/caddy

RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /etc/periodic/monthly/geoip && \
	rm -f /var/cache/apk/*

COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/var/www"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 80 443 2019

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["sudo", "-u", "www", "-g", "www-data", "caddy", "run", "--config", "/etc/caddy/Caddyfile"]
