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
	local t=$(awk '{ gsub("{{[[:space:]]*'"$2"'[[:space:]]*}}", "'"$3"'"); print }' <<< "$1")
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
			if [[ -z "$fs" ]]; then
				t=$(repl2 "$t" "$k" "$v")
			else
				fs=$(repl2 "$fs" "$k" "$v")
			fi
		fi
		;;
	"")
		if [[ ! -z "$fn" ]]; then
			echo > /dev/null
			# TODO: fix this :(
			# t=$(repl2 "$t" "$fn" "$fs")
		fi
		;;
	*)
		# nothing interesting here
		;;
esac

done

cat <<< "$t"
