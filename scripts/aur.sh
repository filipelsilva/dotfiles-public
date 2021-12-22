#!/usr/bin/env bash

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si)

yay -S --noconfirm \
	tealdeer \
	downgrade \
	vimv-git \
	python-gdbgui \
	linux-wifi-hotspot \
	rr
