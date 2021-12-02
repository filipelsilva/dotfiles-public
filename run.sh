#!/bin/bash

echo "#########################"
echo "# Beggining instalation #"
echo "#########################"

sudo echo "# Getting password..."

echo "# 1. Pacman"
./scripts/packages.sh

echo "# 2. AUR"
./scripts/aur.sh

echo "# 3. Pip"
./scripts/pip.sh

echo "# 4. Miscellaneous"
./scripts/other.sh

echo "# 5. Installing zsh plugins..."
./scripts/zsh.sh

echo "# 6. Installing vim plugin managers..."
./scripts/vim.sh

echo "# 7. Linking dotfiles..."
./scripts/linker.sh

echo "# 8. Post instalation things..."
./scripts/post.sh
