#!/usr/bin/env bash

packages=(
	7-zip-full
	atool
	forgit-git
	gef-git
	cht.sh-git
	downgrade
	vimv-git
	rr-bin
)

desktop_packages=(
	onedrive-abraunegg-git
	discord_arch_electron
	zoom
	noisetorch
	ventoy-bin
	optimus-manager
	optimus-manager-qt
	cpufreqctl
)

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
