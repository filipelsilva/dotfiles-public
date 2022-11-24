#!/bin/bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || return
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

(
cd headless || return
for folder in *; do
	stow --restow "$folder"
done
)

if [[ -n $DOTFILES_FULL ]]; then
	(
	cd desktop || return
	for folder in *; do
		stow --restow "$folder"
	done
	)
fi
