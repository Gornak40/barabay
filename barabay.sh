#!/usr/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <template>"
	exit 1
fi

t=$(cat "$1")

while read -r p; do

case "$p" in
	*$'\t'*)
		k=${p%%$'\t'*}
		v=${p#*$'\t'}
		t=$(awk '{ gsub("{{[[:space:]]*'$k'[[:space:]]*}}", "'$v'"); print }' <<< $t)
		;;
	*)
		;;
esac

done

cat <<< $t
