#!/bin/bash

function link_file() {
	file="${1#*/}"
	new_file="${file#*/}"
	new_file="$HOME/${new_file#*/}"
	new_file_dirname="$(dirname "$new_file")"
	echo "$file -> $new_file"
	if [[ ! -d $new_file_dirname ]]; then
		mkdir --parents "$new_file_dirname"
	fi
	ln -s "$PWD/$file" "$new_file"
}

function link_folder() {
	folder=$1
	for file in $(find "$folder" -type f -not -path '*/\.git/*'); do
		link_file "$file"
	done
}

FOLDER=0
NAME="file"
ARG="-type f"

while getopts "d" opt; do
	case "$opt" in
		"d")
			FOLDER=1
			NAME="folder"
			ARG="-type d"
			;;
		*)
			echo "Unsupported option. Exiting."
			exit 1
			;;
	esac
done

if [[ "$(basename $PWD)" != "dotfiles" ]]; then
	cd "$HOME/dotfiles"
fi

PS3="Select $NAME to link: "
select linkee in $(find $ARG -not -path '*/\.git/*'); do
	if [[ "$FOLDER" = 1 ]]; then
		link_folder "$linkee"
	else
		link_file "$linkee"
	fi
done
