#!/usr/bin/env bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || exit
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

packages=( # {{{
	bvi        # Vi-like hex editor
	pup        # Like jq, but for HTML (parsing)
	cht.sh-git # Cheat sheet
	downgrade  # Downgrade packages
	forgit-git # Git aliases with fzf
	rar        # Archive management
	mprocs     # Run multiple commands in parallel
	rr-bin     # Record process to debug
	lurk       # Alternative to strace
) # }}}

desktop_packages=( # {{{
	# PDF management
	cpdf
	diff-pdf

	# Other packages
	zoom
	visual-studio-code-bin
	onedrive-abraunegg     # OneDrive client
	ventoy-bin             # Make multiboot USB drives
	dragon-drop            # Drag-and-drop source/sink
	spek                   # Audio inspector
	openasar-git           # Make Discord faster

	# Fonts
	ttf-ms-win10-auto
)

# Switchable graphics in laptops
if laptop-detect && lspci | grep -qi "nvidia"; then
	desktop_packages+=(
		auto-cpufreq
		optimus-manager
		optimus-manager-qt
	)
fi
# }}}

if [[ -n $DOTFILES_FULL ]]; then
	packages+=("${desktop_packages[@]}")
fi

git clone https://aur.archlinux.org/yay.git "$HOME/.yay"
(cd "$HOME/.yay" && makepkg -si --noconfirm)

yay -S --noconfirm "${packages[@]}"
