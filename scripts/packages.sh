#!/bin/bash

if [[ "$(basename $PWD)" != "dotfiles" ]]; then
	cd "$HOME/dotfiles"
fi

if [[ -z "$DOTFILES_FULL" ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

packages=( # {{{
	# Linux kernel, base packages
	base
	base-devel
	linux
	linux-firmware
	util-linux

	# Other basic utilities
	binutils
	coreutils
	diffutils
	findutils
	pciutils

	# Find filenames quickly
	mlocate

	# Pacman scripts
	pacman-contrib

	# Find packages associated with program
	pkgfile

	# Shells and respective completions
	bash
	bash-completion
	zsh
	zsh-completions

	# Dotfile manager
	stow

	# Text editors
	ed
	vi
	gvim # why gvim and not vim? Clipboard support
	neovim

	# Terminal multiplexer
	tmux
	tmuxp # automatically create tmux session with layouts

	# VCS
	git
	tk # gitk dependency

	# Archive management
	atool
	gzip
	zip
	unzip
	p7zip
	fastjar

	# Network stuff
	curl
	wget
	aria2
	lynx
	socat
	openbsd-netcat
	nmap
	traceroute
	dnsutils
	tcpdump
	bind

	# System monitoring
	htop
	btop
	glances
	sysstat
	iftop

	# Python and related packages (some of them used for gdb/gef/pwndbg)
	python
	python-pip
	pypy
	pypy3
	bpython
	python-pynvim
	python-keystone
	python-capstone

	# C/Cpp and related packages
	gcc
	gdb
	pwndbg
	indent
	valgrind
	ctags
	nmap

	# Java
	jdk-openjdk

	# Go
	go

	# Rust
	rustup

	# JSON
	jq
	jc

	# Shell script static analysis
	shellcheck

	# Auto builder
	make
	cmake

	# Code counter
	cloc
	tokei

	# Profile and benchmark programs
	time
	hyperfine
	strace
	perf
	cargo-flamegraph

	# Finders
	fzf
	fd
	the_silver_searcher
	ripgrep
	ripgrep-all

	# Memory management
	duf
	dust
	diskus

	# Information fetchers
	neofetch
	onefetch

	# Fonts
	terminus-font

	# Other packages
	entr				# Run commands when files change
	rlwrap				# Readline wrapper
	bat					# Cat with syntax highlighting
	hexyl				# Hex viewer
	tealdeer			# Cheat sheet for common programs
	ascii				# Show character codes
	words				# Populate /usr/share/dict with list of words
	datamash			# Manipulate data in textual format
	lnav				# Logfile Navigator
	zoxide				# Autojump to recent folders
	tree				# List files in tree format
	pipe-rename			# Rename files in your $EDITOR
	magic-wormhole		# Send/Receive files
) # }}}

desktop_packages=( # {{{
	# Display management
	arandr
	autorandr
	brightnessctl
	redshift
	xdotool # X11 automation tool

	# Window manager
	i3-wm
	i3status
	i3lock
	xss-lock
	rofi

	# Terminal emulator
	alacritty

	# Browser
	firefox
	torbrowser-launcher

	# Video/Audio management
	vlc
	mpv
	yt-dlp
	flac
	sox
	ffmpeg
	handbrake
	kid3
	kid3-common
	playerctl
	streamlink	# Pipe streams into a video player
	pavucontrol	# Control audio sources/sinks

	# Torrent management
	transmission-cli
	transmission-gtk

	# Image management
	feh
	gthumb
	perl-image-exiftool
	imagemagick
	maim # Screenshot utility
	gimp
	krita
	inkscape

	# Theme management
	arc-gtk-theme
	lxappearance

	# File management
	xdg-user-dirs
	thunar
	thunar-archive-plugin
	file-roller

	# PDF management
	pandoc
	pdftk
	okular
	zathura
	zathura-djvu
	zathura-pdf-mupdf
	zathura-ps

	# OCR
	tesseract
	tesseract-data-por
	tesseract-data-eng

	# Clipboard management
	xclip
	xsel

	# Fonts
	noto-fonts
	noto-fonts-emoji
	noto-fonts-cjk
	ttc-iosevka
	ttf-hack
	ttf-jetbrains-mono
	ttf-input
	ttf-monoid

	# Other packages
	laptop-detect		# Returns 0 if host is laptop, 1 otherwise
) # }}}

if [[ -n "$DOTFILES_FULL" ]]; then
	packages+=(${desktop_packages[@]})
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm ${packages[@]}

# For the rustup package, so that rustc and cargo work out of the box
rustup default stable

# For pkgfile package, in order to search packages
sudo pkgfile --update
