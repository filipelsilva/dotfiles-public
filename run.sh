#!/usr/bin/env bash

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# 1. Pacman"
./scripts/packages.sh $1

echo "# 2. AUR"
./scripts/aur.sh

echo "# 3. Pip"
./scripts/pip.sh

echo "# 4. Miscellaneous"
./scripts/other.sh

echo "# 5. Linking dotfiles..."
./scripts/linker.sh $1

echo "# 6. Post instalation things..."
./scripts/post.sh $1
