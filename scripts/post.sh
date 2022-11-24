#!/bin/bash

if [[ "$(basename "$PWD")" != "dotfiles" ]]; then
	cd "$HOME/dotfiles" || return
fi

if [[ -z $DOTFILES_FULL ]]; then
	source scripts/argparse.sh
	parse_arguments "$@"
fi

# Set default shell
chsh -s "$(command -v zsh)"

# Tty font
echo "FONT=ter-v32b" | sudo tee -a /etc/vconsole.conf

# Desktop stuff
if [[ -n $DOTFILES_FULL ]]; then
	# Create user directories
	xdg-user-dirs-update

	# Create xinitrc file
	echo "#!/bin/sh" >> "$HOME/.xinitrc"
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
