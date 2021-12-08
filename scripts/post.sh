#!/usr/bin/env bash

# Set default shell
chsh -s "$(command -v zsh)"
zsh -c "source $HOME/.zshrc"

# Vi mode in other programs
echo "set editing-mode vi" >> $HOME/.inputrc

# Install neovim plugins
nvim --headless +PackUpdate +PackStatus +quitall

# For usage with optimus-manager

# echo "#!/bin/sh" >> $HOME/.xinitrc
# echo "/usr/bin/prime-offload" >> $HOME/.xinitrc
# echo "i3" >> $HOME/.xinitrc
# echo "exit" >> $HOME/.xinitrc

# If not using optimus-manager (i.e. not on a laptop)

# echo "#!/bin/sh" >> $HOME/.xinitrc
# echo "exec i3" >> $HOME/.xinitrc
