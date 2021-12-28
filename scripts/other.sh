#!/usr/bin/env bash

# Rustc / Rustup / Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#source $HOME/.cargo/env # If there is the need to install cargo packages
