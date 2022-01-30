#!/usr/bin/env bash

packages=(
	forgit-git
	gef-git
	cht.sh-git
	downgrade
	vimv-git
	scc-bin
	rr-bin
	python-gdbgui
	mermaid-cli
	sysz
)

desktop_packages=(
	discord_arch_electron
	zoom
	linux-wifi-hotspot
	optimus-manager
	optimus-manager-qt
)

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

sudo pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
