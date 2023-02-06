#!/usr/bin/env bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || exit
fi

if [[ -z $DOTFILES_FULL ]]; then
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

	# Man pages and info
	man-db
	man-pages
	texinfo

	# Other basic utilities
	binutils
	coreutils
	diffutils
	findutils
	iputils
	moreutils
	pciutils

	# Find filenames quickly
	mlocate

	# Pacman scripts
	pacman-contrib

	# Find packages associated with program
	pkgfile

	# Calculators
	bc
	libqalculate
	qalculate-qt

	# Shells and respective completions
	bash
	bash-completion
	zsh
	zsh-completions

	# Dotfile manager
	stow

	# Text editors
	ed
	sed
	sd
	vi
	gvim # why gvim and not vim? Clipboard support
	neovim

	# Pagers
	less
	lesspipe

	# Terminal multiplexer
	screen
	tmux
	tmuxp # automatically create tmux session with layouts
	tmate # share tmux session

	# VCS
	git
	git-filter-repo
	tk         # gitk dependency
	github-cli # github cli
	glab       # gitlab cli

	# File management
	rsync
	progress

	# Archive management
	atool
	gzip
	zip
	unzip
	p7zip
	fastjar

	# Memory management
	duf
	dust
	diskus
	ncdu
	dua
	fdupes

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
	dog

	# System monitoring
	procps-ng
	procs
	htop
	bottom
	sysstat
	iftop
	nethogs
	bandwhich
	nvtop

	# Python and related packages (some of them used for gdb/gef/pwndbg)
	python
	python-pip
	pypy
	pypy3
	python-black
	python-pwntools
	python-pyperclip
	python-pynvim
	python-keystone
	python-capstone
	sagemath

	# C/Cpp and related packages
	gcc
	gdb
	gef
	peda
	pwndbg
	indent
	valgrind
	ctags

	# Java
	jdk-openjdk

	# Go
	go

	# Lua
	lua

	# Rust
	rustup

	# Ruby
	ruby
	rubygems

	# JavaScript
	nodejs
	npm

	# Perl
	perl

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
	ltrace
	perf
	cargo-flamegraph

	# Finders
	fzf
	fd
	the_silver_searcher
	pdfgrep
	ripgrep
	ripgrep-all

	# Information fetchers
	neofetch
	onefetch

	# Fonts
	terminus-font

	# Other packages
	ctop           # Top for containers
	parallel       # Xargs alternative
	entr           # Run commands when files change
	gping          # Ping, but with a graph
	rlwrap         # Readline wrapper
	bat            # Cat with syntax highlighting
	hexyl          # Hex viewer
	tealdeer       # Cheat sheet for common programs
	ascii          # Show character codes
	words          # Populate /usr/share/dict with list of words
	datamash       # Manipulate data in textual format
	lnav           # Logfile Navigator
	zoxide         # Autojump to recent folders
	tree           # List files in tree format
	pipe-rename    # Rename files in your $EDITOR
	perl-rename    # Rename files using Perl regex
	magic-wormhole # Send/Receive files
	openssh        # SSH programs
) # }}}

desktop_packages=( # {{{
	# Display management
	arandr
	autorandr
	brightnessctl
	redshift
	xdotool	# X11 automation tool

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
	chromium
	torbrowser-launcher

	# Video/Audio management
	vlc
	mpv
	clementine
	yt-dlp
	flac
	sox
	ffmpeg
	handbrake
	kid3
	kid3-common
	playerctl
	obs-studio
	spotify-launcher # Spotify install in home folder
	streamlink       # Pipe streams into a video player
	pavucontrol      # Control audio sources/sinks

	# Torrent management
	transmission-cli
	transmission-gtk

	# Image management
	sxiv
	feh
	gthumb
	perl-image-exiftool
	imagemagick
	gimp
	krita
	inkscape
	mediainfo
	maim     # Screenshot utility
	guvcview # Camera

	# Theme management
	arc-gtk-theme
	lxappearance

	# File management
	xdg-user-dirs
	thunar
	thunar-archive-plugin
	thunar-volman
	tumbler            # Thunar preview window
	file-roller        # Archive manager for thunar
	gvfs               # Enables things like trashing files in Thunar
	ntfs-3g            # Support for NTFS drives
	lxsession          # This includes lxpolkit, in order to be able to mount some drives
	perl-file-mimeinfo # Detect MIME type of files

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
	font-manager
	noto-fonts
	noto-fonts-emoji
	noto-fonts-cjk
	ttc-iosevka
	ttf-hack
	ttf-jetbrains-mono
	ttf-input
	ttf-monoid
	ttf-ubuntu-font-family

	# Other packages
	discord
	texlive-most
	libreoffice-still
	tigervnc      # VNC server/client
	remmina       # Remote desktop client
	barrier       # KVM
	bless         # Hex editor
	gpick         # Color picker
	mypaint       # Drawing table
	scrcpy        # Android screen mirroring and control
	laptop-detect # Returns 0 if host is laptop, 1 otherwise
) # }}}

if [[ -n $DOTFILES_FULL ]]; then
	packages+=("${desktop_packages[@]}")
fi

sudo -v; sudo pacman -Syu --noconfirm
sudo -v; sudo pacman -S --noconfirm "${packages[@]}"

# For the rustup package, so that rustc and cargo work out of the box
rustup default stable

# For pkgfile package, in order to search packages
sudo -v; sudo pkgfile --update
