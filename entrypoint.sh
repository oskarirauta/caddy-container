#! /bin/sh
#
# entrypoint.sh

set -e

# execute any pre-init scripts
for f in /scripts/entrypoint.d/*sh; do
	[ -e "$f" -a -x "$f" ] && "$f"
done

exec "$@"
