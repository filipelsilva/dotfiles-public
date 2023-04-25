#!/usr/bin/env bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || exit
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

# Set default shell
chsh -s "$(command -v zsh)"

# Tty font
echo "FONT=ter-v32b" | sudo tee -a /etc/vconsole.conf

# TLDR (tealdeer) auto update
if [[ -x $(command -v tldr) ]]; then
	mkdir -p "$HOME/.config/tealdeer"
	{
		echo "[updates]"
		echo "auto_update = true"
	} >> "$HOME/.config/tealdeer/config.toml"
fi

# Desktop stuff
if [[ -n $DOTFILES_FULL ]]; then
	# Create user directories
	xdg-user-dirs-update

	# Create xinitrc file # TODO this is untested
	echo "#!/bin/sh" >> "$HOME/.xinitrc"
	{
		echo "autorandr --change --skip-options crtc"
		echo "./$HOME/.fehbg"
		echo "xrdb -merge -I$HOME ~/.Xresources"
		echo "xset s off && xset -b -dpms"
		echo "setxkbmap -layout us -variant altgr-intl -option ctrl:swapcaps"
		echo "lxpolkit &"
		echo "pkill -9 redshift; redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq '.location.lat, .location.lng' | tr '\n' ':' | sed 's/:$//') &"
		echo "optimus-manager-qt &"
		echo "xss-lock -- i3lock &"
		echo "nm-applet &"
		echo "blueman-applet &"
		echo "playerctld daemon &"
	} >> "$HOME/.xinitrc"
	if [[ -f /usr/bin/prime-offload ]]; then
		{
			echo "/usr/bin/prime-offload"
			echo "i3"
			echo "exit"
		} >> "$HOME/.xinitrc"
	else
		echo "exec i3" >> "$HOME/.xinitrc"
	fi
fi
