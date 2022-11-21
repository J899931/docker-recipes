# ~/.bashrc: executed by bash(1) for non-login shells.

export DISPLAY="${REMOTEHOST}:0.0"
export REMOTEHOST="${REMOTEHOST:=localhost}"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# bash :: environment variables {{{
# =================================

export KEYMAP=us
export LANG=en_US.UTF-8
unset LANGUAGE             # LANGUAGE is not dealt with consistently by programs.
export LC_CTYPE=$LANG
export LC_NUMERIC=$LANG
export LC_TIME=$LANG
export LC_COLLATE=$LANG
export LC_MONETARY=$LANG
export LC_MESSAGES=$LANG
export LC_PAPER=$LANG
export LC_NAME=$LANG
export LC_ADDRESS=$LANG
export LC_TELEPHONE=$LANG
export LC_MEASUREMENT=$LANG
export LC_IDENTIFICATION=$LANG
unset LC_ALL               # Should only be set for debugging / testing.
unset MAIL                 # Disable mail.
unset MAILCHECK            # Disable mail.
unset MAILPATH             # Disable mail.
export TMP=/tmp            # This is suppose to be the standard tmp directory.
export TEMP=$TMP           # Some programs use this for tmp directory, redirect it to standard.
export TZ=America/Chicago  #

export FTP_PASSIVE=${FTP_PASSIVE:-1}
export GPG_TTY=$(tty)

if [[ -x /usr/bin/vim ]]; then
	export EDITOR=/usr/bin/vim
	export GIT_EDITOR=$EDITOR
	export SUDO_EDITOR=$EDITOR
	export VISUAL=$EDITOR
fi

if [[ -x /usr/bin/lynx ]]; then
	export BROWSER=/usr/bin/lynx
	export BROWSER_CLI=$BROWSER
fi

if [[ -x /usr/bin/less ]]; then
	export PAGER=/usr/bin/less
	export MANPAGER=$PAGER
	export READNULLCMD=$PAGER
fi
# }}}

umask 022

# bash history {{{
# ================

# BASHOPTS that affect bash history.
shopt -s cmdhist          # save all lines of a multiple-line command in the same history entry
shopt -s lithist          # Use newline characters instead of semi-colons for multi-line commands
shopt -s histappend       # Disable overwriting history on exit, instead append commands
# NOTE: Do not export these variables so they don't interfere with other programs
# NOTE: Without histappend, HISTSIZE should be the same or more than HISTFILESIZE, or it's pointless when it overwrites

# ignoreboth =
#   ignorespace - Don't record lines that start with spaces.
#   ignoredups - Don't record lines that are duplicates of previous lines.
#   erasedups - Remove all previous lines in history that match the command.
HISTCONTROL=ignorespace

# History file location.
HISTFILE="${HOME}/.bash_history"

# History stored on disk.
HISTFILESIZE=4096

# History stored in memory.
HISTSIZE=1024

# ISO 8601 datetime
HISTTIMEFORMAT='[%FT%T%z] '
# }}}

# bash :: shell options {{{
# =========================

# bash :: BASHOPTS
# ----------------

# NOTE: These are not POSIX-compliant options

# shopt -s autocd                  # type directory names without needing to prepend `cd`
shopt -s checkwinsize            # Update $LINES & $COLUMNS after each command
shopt -s cdspell                 # correct minor errors in the spelling of a directory component with `cd`
shopt -s dirspell                # corrector directory names for spelling of word completion
shopt -s dotglob                 # Include dotfiles in wildcard expansion.
shopt -s no_empty_cmd_completion # Disable searching PATH for completions on an empty line
shopt -u mailwarn                # Disable mail warnings
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
shopt -s nocaseglob              # Match wildcards case-insensitively.

# bash :: SHELLOPTS
# -----------------

# NOTE: These are POSIX-compliant options

set -o noclobber # Prevent file overwrite on stdout redirection, use `>|` to force redirection to an existing file
set -o notify    # Notify when background jobs finish
set -0 vi        # vi-like terminal.
# }}}

# TeleType {{{
# ============

# `stty --all` - List all stty key bindings
# Teletype takes precedence over bash and other input reading programs.
# Key mapping conflicts usually must be resolved here first.
# Interesting idea I saw to only activate in approprate terminals:
# [[ tty --silent ]] && stty lwrap undef # Unbind Ctrl-V
stty -echoctl     # Disable echoing control characters
# stty -ixon      # Disable XON/XOFF Flow Control so you can remap <C-S>, <C-Q>, and prevent vim from hanging w/<C-S>
# stty -ixoff     # Disable sending of start/stop characters
# stty ixany      # Enable allowing any character to restart output
# stty iutf8      # assume input characters are UTF-8 encoded
stty lnext undef  # Unbind Ctrl-v
stty start undef  # Unbind Ctrl-s (DC3)
stty stop undef   # Unbind Ctrl-q (DC1)
stty werase undef # Unbind Ctrl-w (erase last word typed)
# }}}

# GNU Core Utilities {{{
# ======================

# NOTE: These can affect one or more GNU Core Utilities programs

# Uncomment below to use default dircolors.
# [[ -r ~/.dir_colors ]] && eval $(dircolors --bourne-shell ~/.dir_colors) || $(dircolors --bourne-shell)
# Use solarized dark colors by default.
export LS_COLORS="no=00:rs=0:fi=00:di=34:ln=35:mh=04;35:st=04;37;44:ow=34;40:tw=01;37;44:pi=1;92;44:so=35;44:bd=2;97;43:cd=1;97;43:or=31:mi=37;41:su=01;37:sg=01;04;37:ca=01;37:ex=91:"

# Show filesizes in human friendly format.
export BLOCK_SIZE=human-readable # `df`, `du`, `ls`

# Disable adding quotes around filenames with special / problematic characters
# export QUOTING_STYLE=literal   # `ls`

# Formats how time is displayed in ls commands
# https://superuser.com/questions/310914/permanently-change-date-time-format-for-ls
# http://rene.kabis.org/2011/05/07/linux-and-displaying-dates-in-iso-8601-format/
export TIME_STYLE=long-iso       # `ls`, also "fixes" `ls` ignoring LC_TIME
# }}}

# less {{{
# ========

export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESSCHARSET=UTF-8
export LESSHISTFILE="${HOME}/less_history"
export LESSHISTSIZE=1024
# export LESSQUIET=1
if [[ -x /usr/bin/lesspipe ]]; then
	# Make less work better with non-text files
	export LESSOPEN="| /usr/bin/lesspipe %s"
	export LESSCLOSE="/usr/bin/lesspipe %s %s"
	eval "$(lesspipe)"
fi
# }}}

# bash :: aliases {{{
# ===================

# NOTE: For gnu coreutils like `ls` and `df` human-readable blocksizes are already set.

# cd typo guard...
alias cd..='cd ..'
# cd skip using `cd`.
alias ..='cd ../'         # up 1 dir
alias ...='cd ../../'     # up 2 dirs
alias ....='cd ../../../' # up 3 dirs

# Check what commands will do.
alias testcmd='command -V'

alias date='date --iso-8601=seconds'
alias dateutc='date --utc'

alias du='du --total'
alias du1='du --max-depth=1'

alias ls='ls --color=auto --group-directories-first --sort=extension'
alias lls='ls -l'                              # Show long list
alias la='ls --almost-all'                     # Show all files
alias lla='la -l'                              # Show files only, verbose
alias ld='ls --directory */'                   # Show directories only
alias lld='ls --directory -l */'               # Show directories only, verbose
alias lf="ls | egrep --invert-match '^d'"      # Show files only
alias llf="ls -l | egrep --invert-match '^d'"  # Show files only, verbose info

alias dir='dir --color=auto --format=vertical'
alias vdir='vdir --color=auto --format=long'

alias diff='diff --color=auto'

alias grep='grep --color=auto --exclude-dir=.git'
alias egrep='egrep --color=auto --exclude-dir=.git'
alias fgrep='fgrep --color=auto --exclude-dir=.git'
alias rgrep='grep --line-number --recursive'

alias root='sudo su --login'

# make sudo work with command completion.
alias sudo='sudo '
# Sudo the last command.
alias frak='sudo $(history -p !!)'

[[ -x /usr/bin/vim ]] && alias vi='vim'

# Prevent mistakes inside Production environment.
alias rm='timeout 3 rm --interactive --one-file-system --preserve-root --verbose'
alias cp='timeout 8 cp --interactive --one-file-system --verbose'
alias ln='ln --interactive --verbose'
alias mv='timeout 8 mv --interactive --verbose'

alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

#systeminfo
#alias probe="sudo -E hw-probe -all -upload"
#alias sysfailed="systemctl list-units --failed"

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

[[ -x /usr/bin/ss ]] && alias openports='ss --all --numeric --processes --ipv4 --ipv6'
# }}}

# bash :: functions {{{
# =====================

function mkdircd() {
	# Make directory and change into it.
	if [[ $1 = "" ]]; then
		printf "Usage: mkdircd <dir>\n"
	else
		mkdir --parents $1
		cd $1
	fi
}

function showcolors {
	# Output all ANSI terminal colors.
	for style in 0 1 2 3 4 5 6 7; do
		for fg in 30 31 32 33 34 35 36 37; do
			for bg in 40 41 42 43 44 45 46 47; do
				ctrl="\033[${style};${fg};${bg}m"
				echo -en "${ctrl}"
				echo -n "${style};${fg};${bg}"
				echo -en "\033[0m"
			done
			echo
		done
		echo
	done
}
# }}}
