#!/bin/bash

packages=(
	mprocs-bin
	yank
	rar
	atool
	forgit-git
	gef-git
	reple
	inxi
	cht.sh-git
	downgrade
	vimv-git
	rr-bin
	lurk
)

desktop_packages=(
	onedrive-abraunegg-git
	discord_arch_electron
	spotify
	slack
	zoom
	ventoy-bin
	cpufreqctl
	dragon-drop
	ttf-ms-win11-auto
	gdb-frontend-bin
	ocrmypdf
	optimus-manager
	optimus-manager-qt
)

if [[ $1 = "full" ]]; then
	packages+=(${desktop_packages[@]})
fi

git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
