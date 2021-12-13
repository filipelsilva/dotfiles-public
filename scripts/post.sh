#!/usr/bin/env bash

# Set default shell
chsh -s "$(command -v zsh)"
zsh -c "source $HOME/.zshrc"

# Vi mode in other programs
echo "set editing-mode vi" >> $HOME/.inputrc

# Optimus-manager
# echo "#!/bin/sh" >> $HOME/.xinitrc
# echo "/usr/bin/prime-offload" >> $HOME/.xinitrc
# echo "i3" >> $HOME/.xinitrc
# echo "exit" >> $HOME/.xinitrc
