#!/bin/bash

# Set default shell
chsh -s "$(command -v zsh)"
zsh -c "source $HOME/.zshrc"

# Vi mode in other programs
echo "set editing-mode vi" >> $HOME/.inputrc

# Advice for plugins in (Neo)Vim
echo "Do not forget to run ':PackUpdate' in Vim/Neovim!"

# For usage with optimus-manager
# echo "#!/bin/sh" >> $HOME/.xinitrc
# echo "/usr/bin/prime-offload" >> $HOME/.xinitrc
# echo "i3" >> $HOME/.xinitrc
# echo "exit" >> $HOME/.xinitrc

# Else
# echo "#!/bin/sh" >> $HOME/.xinitrc
# echo "exec i3" >> $HOME/.xinitrc
