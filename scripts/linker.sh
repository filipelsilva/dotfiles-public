#!/usr/bin/env bash

# Dotfiles
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.nvim-tmp/undo $HOME/.nvim-tmp/swp $HOME/.nvim-tmp/backup
mkdir -p $HOME/.vim-tmp/undo $HOME/.vim-tmp/swp $HOME/.vim-tmp/backup

ln -s $HOME/dotfiles/files/gdbinit $HOME/.gdbinit
ln -s $HOME/dotfiles/files/gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/files/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/files/inputrc $HOME/.inputrc
ln -s $HOME/dotfiles/files/tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/files/vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/files/zshrc $HOME/.zshrc

if [[ $1 = "full" ]]; then
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/i3status
	mkdir -p $HOME/.config/zathura

	ln -s $HOME/dotfiles/files/alacritty.yml $HOME/.alacritty.yml
	ln -s $HOME/dotfiles/files/i3config $HOME/.config/i3/config
	ln -s $HOME/dotfiles/files/i3statusconfig $HOME/.config/i3status/config
	ln -s $HOME/dotfiles/files/zathurarc $HOME/.config/zathura/zathurarc
fi
