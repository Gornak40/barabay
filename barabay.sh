#!/usr/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <template>"
	exit 1
fi

t=$(cat "$1")


# key<tab>value
getkey(){
	local k=${1%%$'\t'*}
	echo -E "$k"
}


# key<tab>value
getval(){
	local v=${1#*$'\t'}
	echo -E "$v"
}


# {{<spaces>key<spaces>}} -> value
# text,key,value
repl2(){
	local t=$(awk -v value="$3" \
		'{ gsub("{{[[:space:]]*'"$2"'[[:space:]]*}}", value); print }' <<< "$1")
	echo -E "$t"
}


fn="" # section name
ft="" # section template
fs="" # section process

while read -r p; do

case "$p" in
	*$'\t'*)
		k=$(getkey "$p")
		v=$(getval "$p")
		if [[ "${k:0:1}" == "@" ]]; then
			fn="$k"
			ft=$(cat "$v")
			fs="$ft"
		else
			if [[ -z "$fn" ]]; then
				t=$(repl2 "$t" "$k" "$v")
			else
				fs=$(repl2 "$fs" "$k" "$v")
			fi
		fi
		;;
	"@.")
		t=$(repl2 "$t" "$fn" "$fs\n{{ $fn }}")
		fs="$ft"
		;;
	*)
		# nothing interesting here
		;;
esac

done

# TODO: do it more carefully
t=$(repl2 "$t" "@.*" "")

cat <<< "$t"
