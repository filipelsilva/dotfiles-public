#!/usr/bin/env bash

# Install pip
python3 -m ensurepip --upgrade
export PATH=$PATH:$HOME/.local/bin

# Pip programs
pip3 install --user --upgrade pip lizard bpython internetarchive gdbgui tmuxp

# Pip packages (same as programs but are not used as standalone programs)
pip3 install --user --upgrade pynvim capstone pyelftools pycparser setuptools

