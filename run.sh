#!/bin/bash

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# 1. Pacman"
./scripts/packages.sh $1

echo "# 2. AUR"
./scripts/aur.sh $1

echo "# 3. Linker"
stow --restow headless
if [[ $1 = "full" ]]; then
	stow --restow desktop
fi

echo "# 4. Post instalation things..."
./scripts/post.sh $1
