#!/bin/bash

if [[ "$(basename $PWD)" != "dotfiles" ]]; then
	cd "$HOME/dotfiles"
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo -v; sudo echo "# Getting password..."

echo "# Pacman"
./scripts/packages.sh

echo "# AUR"
./scripts/aur.sh

echo "# Linker"
./scripts/linker.sh

echo "# Post instalation things..."
./scripts/post.sh
