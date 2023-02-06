#!/usr/bin/env bash

function parse_arguments() {
	while getopts "f" opt; do
		case "$opt" in
			"f")
				export DOTFILES_FULL=1
				;;
			*)
				>&2 echo "Unsupported option. Exiting."
				exit 1
				;;
		esac
	done
}
