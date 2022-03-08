#!/usr/bin/env bash

# Set default shell
chsh -s "$(command -v zsh)"

# Tty font
echo "FONT=ter-v20b" | sudo tee -a /etc/vconsole.conf

# Desktop stuff
if [ $1 = "full" ]; then
	# Create user directories
	xdg-user-dirs-update

	# Create xinitrc file
	echo "#!/bin/sh" >> $HOME/.xinitrc
	if [ -f /usr/bin/prime-offload ]; then
		echo "/usr/bin/prime-offload" >> $HOME/.xinitrc
		echo "i3" >> $HOME/.xinitrc
		echo "exit" >> $HOME/.xinitrc
	else
		echo "exec i3" >> $HOME/.xinitrc
	fi
fi
