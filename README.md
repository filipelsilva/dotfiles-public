# Filipe Ligeiro Silva's Dotfiles

These are my dotfiles. You could use them to inspire yourself, and make your
own!

The commits are more sporadic on the public version, as I started the private
version way earlier, and might still be trying out new things over there.

## Dotfiles (*per se*)

These consist of configurations for some programs:

### Headless

* gdb
* git
* nvim
* screen
* tmux
* vim
* zsh

### Desktop

* alacritty
* i3
* sxiv
* xresources
* zathura

Readline and locale configurations are also here.

## Installer scripts

Scripts made by me, in order to link the dotfiles to their places and install
all needed packages. Keep in mind: these are **very likely to break**, therefore
**use them at your own risk**.

Usage:

```bash
./scripts/install.sh    # If terminal is all you need
./scripts/install.sh -f # If you want to install the desktop packages as well
```

**Note:** this repo is now using `stow` for linking dotfiles, but a script
(aptly named "stow.sh") is in the *scripts* folder to symlink manually, if
`stow` is not present in your system (e.g., servers). Given the number of
subfolders involved, it might be useful.

Usage:

```bash
./scripts/stow    # Symlinks by file
./scripts/stow -d # Symlinks by folder
```

**A word of caution:** it `stow` is installed, use it. This is a basic script,
assumes that --no-folding is always on, and it might backfire horribly on you
due to some bug.

## Rationale behind the config files

### alacritty.yml

Only changing colors and font, to Gruvbox and Iosevka, respectively. There are
other settings, but nothing of great importance.

### gdbinit

If a symlink to this file is found, the aliases in zsh will source the files
defined in there. This way, you can run default `gdb`, `pwndbg`, and `gef`, all
separated. Before, I had a git repo dedicated to this, but this solution is way
cleaner. This only works with Arch Linux.

### gitconfig

Aliases and some settings to do diffs and merges are defined in here. In order
to put your name and email in the config, create a file in the home directory
called ".gitconfig.user", with the following content (".gitconfig" will include
it):

```
[user]
	email = <your email here>
	name = <your name here>
```

The editor used for the difftool and mergetool is your $EDITOR. In the file
itself, only Vim is defined (sane default), but in .zshrc the options are
overwritten to accomodate the possible (and likely) usage of Neovim.

### i3config and i3statusconfig

Using Gruvbox colors, the keybinds have been defined so that even people with
60% keyboards can do things such as play/pause audio, change brightness, volume,
etc. However, the keybind placement is quite subjective (as is the case with all
config files, actually, but I feel this one might be even less intuitive to
those first seeing it), so I recommend that you keep what you like and discard
what you don't.

### tmux.conf

This config uses `xclip` to manage the clipboard, to make it seamless between
other programs and tmux (vim does not use it by default, but there are keybinds
to use it when needed, as I feel it's better to separate those clipboards).

The theme is the default one, with a slight modification to the right side of
the status bar. Also, it only appears if more than one tab is open. The pane
border status only appears if there is more than one pane.

### screenrc

Just a basic config to support 256 colors. Honestly, this file was just the
excuse I made to try out screen, in case I someday need to use it.

### vimrc

This file's main objective was to be simple and portable (assuming a relatively
recent version of Vim). All keybinds and functions are documented fairly well,
and some plugins were added on order to improve the experience (mostly surround
words with characters, comment stuff quickly, and change indentation settings
according to the file that is being edited). If ripgrep (`rg`) is installed, it
will be used as the grep program, and if `fzf` is installed, it will be used for
the functions to edit files (mapped to \<Leader\>[f,F]), and the fzf-vim plugin
will be installed, which adds integration with ripgrep and some other packages,
to provide some quite useful functions.

It automatically installs a simple plugin manager (minpac) that uses Vim's
runtimepath, if the system has `git` (well, if it hadn't, the probability you
were reading this was quite low anyway). This is used to install the plugins
described in the paragraph above).

### init.vim

This is the part of the config that I don't consider very portable. It
piggybacks on the vimrc described above, and adds many plugins, in order to
leverage Neovim's LSP capabilities. I include a colorscheme as well (Gruvbox
really is the best), and `fzf` is joined by Telescope, which is Neovim only and
also works really well (warning: it is slower with large folders, e.g. your home
folder). The plugins are managed using lazy.nvim instead of minpac (a variable
is declared before sourcing .vimrc to stop minpac from installing itself on
Neovim).

### sxiv

Added keybinds to open file in another app, or set as wallpaper, or copy
filename/image to the clipboard. Colors are defined in XResources file.

### xresources

This file only defines the Gruvbox color scheme for the apps that use this file
for config (like sxiv), and the font for sxiv. As I don't (currently) use XTerm
or other terminal emulator that uses XResources, there is nothing else in this
file.

### zathurarc

This file only exists because I needed to change the clipboard to which Zathura
copies text. And then I added Gruvbox colors, because why not?

### zshrc

The objective of this config was to make it portable (at the very least, the
basic functionality), therefore it has multiple guards that only define some
aliases and options if the package exists, e.g. `fzf` (in the off chance you
haven't read the last 2000 mentions to this package in this readme, it is
**really** awesome and you should have it installed).

As I only use one plugin, and that is forgit (depends on `fzf` as well, but
really useful for Git repos), I have decided to manage it from the Pacman/AUR
repos, instead of using a plugin manager.

The "Functions" section of this file has multiple functions that depend on
certain non default packages and have not been guarded, as I found no clean way
to do this, preferring to not use them or have them break if used.

The completion system is done "by hand", instead of using some package to manage
it. This assures that it works the way I expect it to work always (or *almost*
always), but it might not be your preferred way of using completion. If you
don't like it, I suggest using a package that provides completion, or running
the completion assistant and defining the settings yourself: `autoload -U
zsh-newuser-install && zsh-newuser-install -f`.
