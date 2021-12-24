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
    tmuxp \
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
    python-pip \
    python-pynvim \
    python-setuptools \
    python-pyelftools \
    python-pycparser \
    capstone \
    bpython \
    python-internetarchive \
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
        firefox \
        torbrowser-launcher \
        i3 \
        i3status \
        i3lock \
        xss-lock \
        rofi \
        arandr \
        autorandr \
        feh \
        nomacs \
        maim \
        pavucontrol \
        xdotool \
        arc-gtk-theme \
        lxappearance \
        xdg-user-dirs \
        thunar \
        thunar-archive-plugin \
        file-roller \
        okular \
        redshift \
        playerctl \
        brightnessctl \
        ttc-iosevka \
        ttc-iosevka-ss12
fi
