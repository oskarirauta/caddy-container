#!/bin/sh

exec sudo -u www -g www-data /usr/sbin/caddy "$@"
