#!/bin/bash

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# Cheat.sh
curl https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh
sudo chmod +x /usr/local/bin/cht.sh

# Rustc / Rustup / Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#source $HOME/.cargo/env # If there is the need to install cargo packages

# Pip programs
pip3 install --user --upgrade lizard bpython internetarchive gdbgui

# Pip packages (same as programs but are not used as standalone programs)
pip3 install --user --upgrade pynvim capstone pyelftools 

# Pwndbg + gef + peda (GDB)
git clone https://github.com/filipelsilva/gdb-peda-pwndbg-gef.git $HOME/.gdb-peda-pwndbg-gef
(cd $HOME/.gdb-peda-pwndbg-gef && ./install.sh)
