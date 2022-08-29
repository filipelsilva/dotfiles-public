#!/bin/bash

if [[ "$(basename $PWD)" != "dotfiles" ]]; then
	cd "$HOME/dotfiles"
fi

if [[ -z "$DOTFILES_FULL" ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

packages=( # {{{
	igrep			# Interactive grep using ripgrep
	cht.sh-git		# Cheat sheet
	downgrade		# Downgrade packages
	forgit-git		# Git aliases with fzf
	gef-git			# GDB Enhanced Features
	inxi			# System information
	lurk			# Alternative to strace
	mprocs-bin		# Run multiple commands in parallel
	rar				# Archive management
	reple			# REPL for compiled languages
	rr-bin			# Record process to debug
	yank			# Read input from stdin, select field to copy
) # }}}

desktop_packages=( # {{{
	# PDF management
	cpdf
	diff-pdf

	# Other packages
	zoom
	spotify
	slack-desktop
	discord_arch_electron	# Discord that uses native electron
	onedrive-abraunegg-git	# OneDrive client
	ventoy-bin				# Make multiboot USB drives
	dragon-drop				# Drag-and-drop source/sink
	spek					# Audio inspector
	cpufreqctl				# [FIXME OUTDATED] CPU Power Manager

	# Fonts
	ttf-ms-fonts
)

# Switchable graphics in laptops
if [[ laptop-detect ]] && [[ ! -z $(lspci | grep -i "nvidia") ]]; then
	desktop_packages+=(
		optimus-manager
		optimus-manager-qt
	)
fi
# }}}

if [[ -n "$DOTFILES_FULL" ]]; then
	packages+=(${desktop_packages[@]})
fi

git clone https://aur.archlinux.org/yay.git $HOME/.yay
(cd $HOME/.yay && makepkg -si --noconfirm)

yay -S --noconfirm ${packages[@]}
