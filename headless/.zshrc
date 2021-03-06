# Variables {{{
if (( $+commands[nvim] )); then
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
else
	export EDITOR="vim"
	export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"
fi
export VISUAL="$EDITOR"
export DIFFPROG="$EDITOR -d"

# Override git diff and merge tools
export GIT_CONFIG_COUNT=2
export GIT_CONFIG_KEY_0="difftool.vimdiff.cmd"
export GIT_CONFIG_VALUE_0="$DIFFPROG \$LOCAL \$REMOTE"
export GIT_CONFIG_KEY_1="mergetool.vimdiff.cmd"
export GIT_CONFIG_VALUE_1="$DIFFPROG \$LOCAL \$REMOTE \$MERGED -c '\$wincmd w' -c 'wincmd J'"

# Distro name
export DISTRONAME=$(cat /etc/os-release | grep "NAME" | head -n 1 | cut -d'=' -f2 | tr -d '"')

# Adding folders to PATH {{{
local PATH=$HOME/.local/bin:$PATH

(( $+commands[cargo] )) && PATH=$HOME/.cargo/bin:$PATH

if (( $+commands[go] )); then
	export GOPATH=$HOME/go
	PATH=$GOPATH/bin:$PATH
fi

if (( $+commands[java] )); then
	export JAVA_HOME=/usr/lib/jvm/default
	PATH=$JAVA_HOME/bin:$PATH
fi
# }}}
export PATH

(( $+commands[python] )) && export PYTHONDONTWRITEBYTECODE=1

if (( $+commands[bat] )); then
	export BAT_THEME="ansi"
	export BAT_STYLE="auto"
fi

(( $+commands[alacritty] )) && export TERMINAL="alacritty"
# }}}

# Aliases {{{

# Basic commands
alias -- -="cd -"
alias cp="cp --recursive"
alias bc="bc --mathlib"
alias mkdir="mkdir --parents"
alias wget="wget --continue"
alias ip="ip --color"
alias diff="diff --color"
alias grep="grep --color"
alias info="info --vi-keys"
alias v="$EDITOR"
if (( $+commands[nvim] )); then
	alias vimdiff="nvim -d"
fi

# Ls aliases
# alias ls="ls --color"
alias lsa="ls -A"
alias lsr="ls -R"
alias l="ls -lh"
alias la="ls -lhA"
alias lr="ls -lhR"
alias lar="ls -lhAR"
alias lx="ls -lhAFis"

# Ssh with xterm, for compatibility
alias ssh="TERM=xterm-256color ssh"

# Search for processes
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

# Zsh configuration and reload
alias zshsource="source $HOME/.zshrc && echo 'sourced zshrc'"
alias zshconfig="$EDITOR $HOME/.zshrc && zshsource"

# Git configuration
alias gitconfig="$EDITOR $HOME/.gitconfig"

# i3 configuration and reload
if (( $+commands[i3] )); then
	alias i3source="i3-msg restart"
	alias i3config="$EDITOR $HOME/.config/i3/config && i3source"
fi

# GDB aliases
if [ -f $HOME/.gdbinit ]; then
	alias pwndbg="gdb -quiet -ex init-pwndbg"
	alias gef="gdb -quiet -ex init-gef"
fi
# }}}

# Prompt {{{
setopt prompt_subst

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats '%c%u%b'
zstyle ':vcs_info:*' actionformats '%c%u%b(%a)'

# Replace %# with %(!.#.$) for bash-like prompt
local NEWLINE=$'\n'
local PROMPT_ERROR_HANDLING="%(?..%F{red}%?%f )"
local PROMPT_GIT_INFO='%(!..${vcs_info_msg_0_})'

# local PROMPT_INFO="%n@%M:%1~%#"
local PROMPT_INFO="%M%S%n%s%1~ %#"
# local PROMPT_INFO="%F{green}%n@%M%f:%F{blue}%1~%f%#"

export PROMPT="${PROMPT_ERROR_HANDLING}${PROMPT_INFO} "
export RPROMPT="${PROMPT_GIT_INFO}"
# }}}

# Directory stack {{{
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

function jd() {
	dirs -v
	vared -p "> " -c tmp
	cd +${tmp}
	unset tmp
}

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# }}}

# Completion/Correction {{{
zmodload zsh/complist

# Vi mode for selecting completion
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "l" vi-forward-char

autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
_comp_options+=(globdots)

setopt always_to_end
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_param_slash
setopt complete_in_word
setopt extended_glob
setopt glob_complete
setopt list_types
unsetopt flow_control

# eval "$(dircolors)"
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' add-space true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' cache-path $HOME/.zcompcache
zstyle ':completion:*' completer _expand _complete _ignored _expand_alias _extensions _match _correct _approximate _prefix
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '-- %d --'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' group-order aliases functions builtins commands
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-prompt "%SAt %p: Hit TAB for more, or the character to insert%s"
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/2))numeric)'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt "%SScrolling active: current selection at %p%s"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true

zstyle ':completion:*:*:*:*:corrections' format '-- %d (errors: %e) --'
zstyle ':completion:*:*:*:*:descriptions' format '-- %d --'
zstyle ':completion:*:*:*:*:messages' format '-- %d --'
zstyle ':completion:*:*:*:*:warnings' format '-- no matches found --'
# }}}

# Vi-mode and keybinds {{{
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
autoload -Uz edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

# Suppress delay on Esc key
KEYTIMEOUT=1

# Set vi-mode in Zsh
bindkey -v

# Shift + Tab to reverse cycling order on completion
bindkey "^[[Z" reverse-menu-complete

# Delete characters with Delete and Backspace, respectively
bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char
bindkey "^H" backward-kill-word

# Alt + . to insert last word, as in Emacs mode
bindkey "\e." insert-last-word

# Ctrl-e to edit command line in $EDITOR
bindkey "^E" edit-command-line

# Ctrl-r (or / in normal mode of vi-mode) to search commands
bindkey "^R" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-backward

# Up/Down, Ctrl-p/n, k/j to go up and down while completing partial command
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Add text objects to command line
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
	for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
		bindkey -M $km -- $c select-quoted
	done
	for c in {a,i}${(s..)^:-"()[]{}<>bB"}; do
		bindkey -M $km -- $c select-bracketed
	done
done
# }}}

# Command history {{{
HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time
# }}}

# Other options {{{
setopt hash_list_all
setopt long_list_jobs
setopt no_beep
setopt no_glob_dots
setopt no_hup
setopt no_sh_word_split
setopt notify
# }}}

# Functions {{{

# [..]: go back directories
function ..() {
	local num=$((${1:-1} * 3))
	cd ${(l:num::../:)}
}

# [Take]: mkdir directory and cd to it
function take() {
	mkdir -p $@ && cd ${@:$#}
}

# [Calc]: run calculations quickly
function calc() {
	python3 -c "from math import *; print($*)"
}

# [Colors]: print colors and corresponding codes
function colors() {
	for c in {0..7}; do
		b=$((c+8))
		print -P - "%F{$c}$c%f -> %F{$b}$b%f"
	done
}

# [Open] files
function open() {
	if [ "$#" -ne 0 ]; then
		for arg in $@; do
			(xdg-open $arg > /dev/null 2>&1 &)
		done
	else
		(fzf --multi | xargs -I {} sh -c "xdg-open '{}' > /dev/null 2>&1 &")
	fi
}

# [Linkdump]
function linkdump() {
	lynx -dump -listonly -nonumbers $1 | grep .pdf > dump.txt
	wget -i dump.txt
	rm dump.txt
}

# [K]ill [P]rocess
function kp() {
	local pid=$(ps -ef | sed 1d | eval "fzf --header='[kill:process]'" | awk '{print $2}')
	if [ "x$pid" != "x" ]; then
		echo $pid | xargs kill -${1:-9}
		kp
	fi
}

# Start[x]: to use with optimus-manager, instead of default startx
function x() {
	if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]];
	then
		sudo /usr/bin/prime-switch
		exec startx
	fi
}
# }}}

# Fzf {{{
if (( $+commands[fzf] )); then
	local FZF_KEYBINDS=/usr/share/fzf/key-bindings.zsh
	local FZF_COMPLETION=/usr/share/fzf/completion.zsh
	[ -f $FZF_KEYBINDS ] && source $FZF_KEYBINDS
	[ -f $FZF_COMPLETION ] && source $FZF_COMPLETION

	# Stop fzf completion trigger from colliding with zsh glob operator
	export FZF_COMPLETION_TRIGGER="++"

	# Fzf options
	local fzf_options=(
		--height=30%
		--layout=reverse
		--info=inline
		--multi
		--bind "?:toggle-preview,ctrl-a:toggle-all"
	)

	# Colorscheme overrides
	local colors=(
		--color="fg+:#ebdbb2"
	)

	if [ "$TERM" = "alacritty" ]; then
		fzf_options+=(${colors[@]})
	fi

	# Variables and functions for fzf operation
	export FZF_DEFAULT_OPTS=${fzf_options[@]}

	if (( $+commands[fd] )); then
		local FD_DEFAULT_OPTS=(
			--hidden
			--exclude .git
		)

		export FZF_DEFAULT_COMMAND="fd --type f $FD_DEFAULT_OPTS"
		export FZF_CTRL_T_COMMAND="fd --type f $FD_DEFAULT_OPTS"
		export FZF_ALT_C_COMMAND="fd --type d $FD_DEFAULT_OPTS"

		_fzf_compgen_path() {
			fd $FD_DEFAULT_OPTS . "$1"
		}

		_fzf_compgen_dir() {
			fd --type d $FD_DEFAULT_OPTS . "$1"
		}
	fi
fi
# }}}

# Plugins {{{
local FORGIT_PLUGIN=/usr/share/zsh/plugins/forgit-git/forgit.plugin.zsh
[ -f $FORGIT_PLUGIN ] && source $FORGIT_PLUGIN

(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd j)"
# }}}
