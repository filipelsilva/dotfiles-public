#!/usr/bin/env bash

packages=(
	gef-git
	cht.sh-git
	scc-bin
	downgrade
	vimv-git
	rr-bin
	python-gdbgui
)

desktop_packages=(
	discord_arch_electron
	linux-wifi-hotspot
)

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

sudo pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
