#!/usr/bin/env bash

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# 1. Pacman"
./scripts/packages.sh $1

echo "# 2. AUR"
./scripts/aur.sh

echo "# 3. Miscellaneous"
./scripts/other.sh

echo "# 4. Linking dotfiles..."
./scripts/linker.sh $1

echo "# 5. Post instalation things..."
./scripts/post.sh $1
