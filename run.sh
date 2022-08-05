#!/bin/bash

while getopts "f" opt; do
	case "$opt" in
		"f")
			export DOTFILES_FULL=1
			;;
		*)
			echo "Unsupported option. Exiting."
			exit 1
			;;
	esac
done

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# Pacman"
./scripts/packages.sh

echo "# AUR"
./scripts/aur.sh

echo "# Linker"
stow --restow headless
if [[ -n "$DOTFILES_FULL" ]]; then
	stow --restow desktop
fi

echo "# Post instalation things..."
./scripts/post.sh

unset DOTFILES_FULL
