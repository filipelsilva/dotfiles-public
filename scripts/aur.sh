#!/bin/bash

packages=(
	rar
	atool
	forgit-git
	gef-git
	reple
	cht.sh-git
	downgrade
	vimv-git
	rr-bin
)

desktop_packages=(
	onedrive-abraunegg-git
	discord_arch_electron
	spotify
	slack
	zoom
	ventoy-bin
	cpufreqctl
	gdb-frontend-bin
	optimus-manager
	optimus-manager-qt
)

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
