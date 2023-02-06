#!/usr/bin/env bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || exit
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

(
cd headless || exit
for folder in *; do
	stow --restow "$folder"
done
)

if [[ -n $DOTFILES_FULL ]]; then
	(
	cd desktop || exit
	for folder in *; do
		stow --restow "$folder"
	done
	)
fi
