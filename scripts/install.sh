#!/bin/bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || exit
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

echo "##########################"
echo "# Beginning installation #"
echo "##########################"

sudo -v; sudo echo "# Getting password..."

echo "# Pacman"
./scripts/packages.sh

echo "# AUR"
./scripts/aur.sh

echo "# Linker"
./scripts/linker.sh

echo "# Post installation things..."
./scripts/post.sh
