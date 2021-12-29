#!/usr/bin/env bash

packages=(
	gef
	cht.sh-git
	tealdeer
	downgrade
	vimv-git
	rr
	python-gdbgui
	linux-wifi-hotspot
)

desktop_packages=()

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si)

yay -S --noconfirm ${packages[@]}
