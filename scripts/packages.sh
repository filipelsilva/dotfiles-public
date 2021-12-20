#!/usr/bin/env bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
    zsh \
    zsh-completions \
    bash \
    bash-completion \
    vim \
    neovim \
    tmux \
    git \
    zoxide \
    zip \
    unzip \
    atool \
    curl \
    wget \
    htop \
    glances \
    tree \
    python \
    pypy \
    gcc \
    gdb \
    valgrind \
    fd \
    the_silver_searcher \
    ripgrep \
    ripgrep-all \
    neofetch \
    xclip \
    pkg-config \
    shellcheck \
    make \
    cmake \
    ctags \
    entr \
    rlwrap \
    hexyl \
    bat \
    hyperfine \
    npm \
    ascii \
    go \
    nodejs \
    jq \
    pacman-contrib \
    lynx \
    dnsutils \
    tk

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

