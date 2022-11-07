# Aliases {{{

# Basic commands
alias -- -="cd -"
alias bc="bc --mathlib"
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
if [[ -f $HOME/.gdbinit ]]; then
	alias pwndbg="gdb -quiet -ex init-pwndbg"
	alias gef="gdb -quiet -ex init-gef"
fi
# }}}

# Variables {{{

# PATH and related variables {{{
export PATH
typeset -U PATH

if (( $+commands[python] )); then
	export PYTHONDONTWRITEBYTECODE=1
	PATH="$PATH:$HOME/.local/bin"
fi

(( $+commands[cargo] )) && PATH="$PATH:$HOME/.cargo/bin"

if (( $+commands[go] )); then
	export GOPATH="$HOME/go"
	PATH="$PATH:$GOPATH/bin"
fi

if (( $+commands[java] )); then
	export JAVA_HOME="/usr/lib/jvm/default"
	PATH="$PATH:$JAVA_HOME/bin"
fi

if (( $+commands[bat] )); then
	export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
	export PATH="$PATH:$GEM_HOME/bin"
fi
# }}}

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

# Terminal environment variable
(( $+commands[alacritty] )) && export TERMINAL="alacritty"

# Bat settings
if (( $+commands[bat] )); then
	export BAT_THEME="ansi"
	export BAT_STYLE="auto"
fi
# }}}

# Functions {{{

# [Open] files
function open() {
	if [[ $# -ne 0 ]]; then
		for arg in "$@"; do
			(xdg-open "$PWD/$arg" > /dev/null 2>&1 &)
		done
	else
		(fzf --multi | xargs -I {} sh -c "xdg-open '$PWD/{}' > /dev/null 2>&1 &")
	fi
}

# Start[x]: wrapper around startx to use optimus-manager if needed
function x() {
	if (( $+commands[prime-switch] )); then
		sudo /usr/bin/prime-switch
		exec startx
	else
		startx
	fi
}

# }}}

# Prompt {{{
setopt PROMPT_SUBST

autoload -Uz vcs_info
precmd_functions+=( vcs_info )

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats '%c%u%b'
zstyle ':vcs_info:*' actionformats '%c%u%b(%a)'

# Replace %# with %(!.#.$) for bash-like prompt
local NEWLINE=$'\n'
local PROMPT_GIT_INFO='${vcs_info_msg_0_:- }'
local PROMPT_ERROR_HANDLING="%(?..%F{9}%?%f )"

# local PROMPT_INFO="[%n@%m %1~]%#"
local PROMPT_INFO="%n@%m:%1~%#"
# local PROMPT_INFO="%n@%m %1~ %#"
# local PROMPT_INFO="%m%S%n%s%1~ %#"

export PROMPT="${PROMPT_ERROR_HANDLING}${PROMPT_INFO} "
export RPROMPT="${PROMPT_GIT_INFO}"
# }}}

# Completion {{{
zmodload zsh/complist

# Vi mode for selecting completion
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "l" vi-forward-char

autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
_comp_options+=(globdots)

setopt ALWAYS_TO_END
setopt AUTO_CD
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt LIST_TYPES
unsetopt FLOW_CONTROL

# eval "$(dircolors)"
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' add-space true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
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
HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY_TIME
# }}}

# Other options {{{
setopt HASH_LIST_ALL
setopt LONG_LIST_JOBS
setopt NO_BEEP
setopt NO_GLOB_DOTS
setopt NO_HUP
setopt NO_SH_WORD_SPLIT
setopt NOTIFY
setopt CORRECT_ALL

# Renamer ($ zmv '(*)_(*)_(*)' '$3_$2_$1' # foo_bar_baz -> baz_bar_foo)
autoload -Uz zmv
# }}}

# Fzf {{{
if (( $+commands[fzf] )); then
	local FZF_KEYBINDS="/usr/share/fzf/key-bindings.zsh"
	local FZF_COMPLETION="/usr/share/fzf/completion.zsh"
	[[ -f $FZF_KEYBINDS ]] && source $FZF_KEYBINDS
	[[ -f $FZF_COMPLETION ]] && source $FZF_COMPLETION

	# Stop fzf completion trigger from colliding with zsh glob operator
	export FZF_COMPLETION_TRIGGER=",,"

	# Fzf options
	local fzf_options=(
		"--height 30%"
		"--layout reverse"
		"--info inline"
		"--multi"
		"--bind '?:toggle-preview,ctrl-a:toggle-all'"
		"--preview-window 'right,50%,<50(up,50%)'"
	)

	# Colorscheme overrides
	if [[ $TERM = "alacritty" ]]; then
		local config_file="$HOME/.config/alacritty/alacritty.yml"
		if [[ -f $config_file ]]; then
			local foreground=$(grep "foreground" "$config_file" | cut -d: -f2 | tr -d " |'|\"")
			if [[ -n $foreground ]]; then
				fzf_options+=(
					"--color='fg+:$foreground'"
				)
			fi
		fi
	fi

	# Variables and functions for fzf operation
	export FZF_DEFAULT_OPTS="${fzf_options[@]}"

	if (( $+commands[fd] )); then
		local FD_DEFAULT_OPTS=(
			--hidden
			--exclude ".git"
			--exclude ".hg"
			--exclude ".svn"
			--exclude "CVS"
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
local FORGIT_PLUGIN="/usr/share/zsh/plugins/forgit-git/forgit.plugin.zsh"
[[ -f $FORGIT_PLUGIN ]] && source "$FORGIT_PLUGIN"

(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd j)"
# }}}
