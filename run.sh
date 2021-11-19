#!/bin/bash

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# 1. Pacman"
./scripts/packages.sh

echo "# 2. AUR"
./scripts/aur.sh

echo "# 3. Miscellaneous"
./scripts/other.sh

echo "# 4. Installing zsh plugins..."
./scripts/zsh.sh

echo "# 5. Installing vim plugin managers..."
./scripts/vim.sh

echo "# 6. Linking dotfiles..."
./scripts/linker.sh

echo "# 7. Post instalation things..."
./scripts/post.sh
