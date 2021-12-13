#!/usr/bin/env bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
    zsh \
    git \
    tk \
    curl \
    wget \
    glances \
    htop \
    neovim \
    python \
    pypy \
    gcc \
    valgrind \
    gdb \
    unzip \
    zip \
    tmux \
    lynx \
    tree \
    ripgrep \
    fd \
    the_silver_searcher \
    neofetch \
    xclip \
    pkg-config \
    go \
    make \
    entr \
    ctags \
    rlwrap \
    hexyl \
    bat \
    cmake \
    shellcheck \
    hyperfine \
    onefetch \
    npm \
    atool \
    ascii \
    nodejs \
    pacman-contrib \
    zsh-completions \
    zoxide \
    jq \
    xcape

# For desktop installation:

if [[ $1 = "full" ]]; then
    sudo pacman -S --noconfirm \
        alacritty \
        i3 \
        i3status \
        i3lock \
        maim \
        rofi \
        feh \
        arandr \
        nomacs \
        pavucontrol \
        xdotool \
        arc-gtk-theme \
        lxappearance \
        thunar \
        autorandr \
        thunar-archive-plugin \
        file-roller \
        okular \
        xss-lock \
        redshift \
        playerctl \
        brightnessctl \
        ttc-iosevka \
        ttc-iosevka-ss12
fi

