#!/usr/bin/env bash

# Dotfiles
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.vim-tmp/undo $HOME/.vim-tmp/swp $HOME/.vim-tmp/backup
mkdir -p $HOME/.nvim-tmp/undo $HOME/.nvim-tmp/swp $HOME/.nvim-tmp/backup
ln -s $HOME/dotfiles/files/defaults.vim $HOME/.vimrc
ln -s $HOME/dotfiles/files/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/files/alacritty.yml $HOME/.alacritty.yml
ln -s $HOME/dotfiles/files/zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/files/tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/files/gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/files/gdbinit $HOME/.gdbinit

if [[ $1 = "full" ]]; then
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/i3status
	mkdir -p $HOME/.config/zathura
	ln -s $HOME/dotfiles/files/i3config $HOME/.config/i3/config
	ln -s $HOME/dotfiles/files/i3statusconfig $HOME/.config/i3status/config
	ln -s $HOME/dotfiles/files/zathurarc $HOME/.config/zathura/zathurarc
fi
