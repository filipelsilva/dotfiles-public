#!/usr/bin/env bash

# Dotfiles
mkdir -p $HOME/.config/nvim

ln -nsf $HOME/dotfiles/files/gdbinit $HOME/.gdbinit
ln -nsf $HOME/dotfiles/files/gitconfig $HOME/.gitconfig
ln -nsf $HOME/dotfiles/files/init.lua $HOME/.config/nvim/init.lua
ln -nsf $HOME/dotfiles/files/inputrc $HOME/.inputrc
ln -nsf $HOME/dotfiles/files/tmux.conf $HOME/.tmux.conf
ln -nsf $HOME/dotfiles/files/vimrc $HOME/.vimrc
ln -nsf $HOME/dotfiles/files/zshrc $HOME/.zshrc

if [[ $1 = "full" ]]; then
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/i3status
	mkdir -p $HOME/.config/zathura

	ln -nsf $HOME/dotfiles/files/alacritty.yml $HOME/.alacritty.yml
	ln -nsf $HOME/dotfiles/files/i3config $HOME/.config/i3/config
	ln -nsf $HOME/dotfiles/files/i3statusconfig $HOME/.config/i3status/config
	ln -nsf $HOME/dotfiles/files/zathurarc $HOME/.config/zathura/zathurarc
fi
