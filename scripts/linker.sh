#!/bin/bash

if [[ "$(basename $PWD)" != "dotfiles" ]]; then
	cd "$HOME/dotfiles"
fi

if [[ -z "$DOTFILES_FULL" ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

(
cd headless
for folder in *; do
	stow --restow "$folder"
done
)

if [[ -n "$DOTFILES_FULL" ]]; then
	(
	cd desktop
	for folder in *; do
		stow --restow "$folder"
	done
	)
fi
