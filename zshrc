# Copyright © 1999–2023 Sam Hocevar <sam@hocevar.net>
#
# This file is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# to Public License, Version 2, as published by the WTFPL Task Force.
# See http://www.wtfpl.net/ for more details.

##
## Handy function to update dotfiles in just one go
##

function update-dotfiles() {(
    set -e
    DOTFILES="$(realpath "$(dirname "$(readlink "${(%):-%x}")")")"
    echo "[OK] Found dotfiles repository in ${DOTFILES}"
    git -C "${DOTFILES}" pull
    echo "[OK] Updated repository"
    "${DOTFILES}/setup.sh"
)}

##
## Interactive shell environment
##

# Default editor: neovim if available, otherwise vim
for f in nvim vim; do
    if which "${f}" >/dev/null; then
        export VISUAL="${f}"
        export EDITOR="${f}"
        break
    fi
done

# Use less instead of more
if which less >/dev/null; then
    export PAGER=less
fi

# Sometimes this is not defined
export MAIL="/var/mail/${USERNAME}"

##
## Shell history
##

export HISTFILE="${HOME}/.history"
export HISTORY=256
export HISTSIZE=2048
export SAVEHIST=2048

setopt   share_history # Instead of append_history
setopt   bang_hist
setopt   csh_junkie_history
unsetopt extended_history
unsetopt hist_allow_clobber
unsetopt hist_beep
setopt   hist_ignore_all_dups # Could be just hist_ignore_dups
unsetopt hist_ignore_space
setopt   hist_no_store
setopt   hist_verify

##
## Function aliases
##

# Better ls on foreign systems
case "$(uname)" in
    *BSD|SunOS)
        if which gnuls >/dev/null; then
            alias ls='gnuls --classify --tabsize=0 --literal --color=auto'
        fi
        ;;
    *)
        alias ls='ls --classify --tabsize=0 --literal --color=auto'
        ;;
esac

# Better grep on foreign systems
alias grep='grep --color=auto'
if which rgrep >/dev/null; then
    alias rgrep='rgrep --color=auto'
else
    alias rgrep='grep -R --color=auto'
fi

# Do not accidentally clobber files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
unsetopt clobber # Force ">|" instead of letting ">" clobber files

# Always load the math library in bc
alias bc='bc -l'

# Make sure there is an alias for "vi"
if ! which vi >/dev/null; then
    alias vi=vim
fi

##
## Terminal, prompt and colours
##

# Tell the terminal to handle 8-bit characters
stty pass8 -ixon

# Force emacs mode (to bypass ex mode detection from $VISUAL)
bindkey -e

# Search in history, handle home, pgup etc.
bindkey '^[[1~' beginning-of-line       # Home
bindkey '^[[4~' end-of-line             # End
bindkey '^[[3~' delete-char             # Del
bindkey '^[[2~' overwrite-mode          # Insert
bindkey '^[[5~' history-search-backward # PgUp
bindkey '^[[6~' history-search-forward  # PgDn

# Pick up an emoji to indicate the system; helpful on WSL where the same machine
# runs both a Windows and a Linux kernel.
case "$(uname)" in
    Linux)  local logo='🐧' ;;
    MINGW*) local logo='🪟' ;;
    Darwin) local logo='🍎' ;;
    *BSD)   local logo='😈' ;;
    SunOS)  local logo='🌞' ;;
esac

# This is how we would activate a modern style prompt
#autoload -Uz promptinit
#promptinit
#prompt fire

# Full color prompt
export PS1="%{%B%F{cyan}%}%D{%d/%m} %T %{%F{red}%}%n%{%F{yellow}%}@%{%F{white}%}%m%{%F{yellow}%}${logo}%{%F{green}%}%~%{%F{yellow}%}%#%{%f%b%} "
export PS2='> '

# Clean up
unset logo

# Handle LS_COLORS
if which dircolors >/dev/null; then
    for f in ~/.dir_colors /etc/dir_colors; do
        if [ -r "$f" ]; then
            eval "$(dircolors "$f")"
            break
        fi
    done
fi

# Handle PS_COLORS and TOP_COLORS (doesn't seem to work)
if which pscol >/dev/null; then
    eval "$(pscol)"
fi

##
## Various zsh options
##

# Misc options
unsetopt beep # disable beep
setopt   bsd_echo # disallow echo escape sequences without -e
unsetopt err_exit # execute ZERR if exit code != 0
setopt   exec # really execute command
setopt   hash_cmds # hash commands
setopt   hash_dirs # hash dirs
setopt   hash_list_all # hash current directory when completing
unsetopt ignore_eof # allow Ctrl-d to quit
setopt   multios # allow multiple redirections (using implicit cat)
setopt   path_dirs # add PATH to the dir list
setopt   print_exit_value # print exit code != 0
unsetopt rm_star_silent # ask for rm * confirmation
setopt   prompt_subst # replace strings inside prompt
setopt   rcs # read standard RC files
setopt   glob_dots # don't require . in command line to match
unsetopt mark_dirs # don't append / when extending directory names
setopt   numeric_glob_sort # sort foo3.txt before foo20.txt
setopt   correct # correct commands
unsetopt correct_all # do not correct command arguments

# Directory navigation
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

# Job management
setopt   auto_resume
unsetopt bgnice
unsetopt hup
setopt   long_list_jobs
setopt   monitor
setopt   notify

##
## Completion
##

setopt   always_to_end # completion sends cursor to EOL
setopt   auto_list
unsetopt auto_menu
setopt   menu_complete
setopt   auto_remove_slash
setopt   complete_in_word
setopt   glob_complete
setopt   list_ambiguous
unsetopt list_beep
setopt   list_types
unsetopt rec_exact

compctl -g '*(-/)' cd # allow links with '-'

##
## Windows-specific stuff (on MSYS2)
##

if [ "${OSTYPE}" = 'msys' ]; then
    # Some utilities are capitalised and this confuses the hell out of zsh autocorrect
    for b in arp hostname netstat ping route tracert; do
        alias "${b}=${b:u}.EXE"
    done

    # Slightly better version of "start" which acts on files and relative paths
    function start() {
        if [ -d "$1" ]; then
            (cd "$1" && command start .)
        elif [ -f "$1" ]; then
            (cd "$(dirname "$1")" && command start "$(basename "$1")")
        else
            command start "$@"
        fi
    }

    # The faketime utility won’t work on Windows but we can at least emulate its
    # behaviour with Git.
    function faketime() {
        date="$(date -d "$1")"
        shift
        GIT_AUTHOR_DATE="$date" GIT_COMMITER_DATE="$date" "$@"
    }
fi

##
## Utility functions
##

# Handy command to format man pages
function mf() {
    tbl $* | nroff -mandoc | less -s
}

# Create a Go version tag from the current Git commit
function git-go-version() {
    TZ=UTC git --no-pager show --quiet --abbrev=12 --date='format-local:%Y%m%d%H%M%S' --format='%cd-%h'
}

# Generate passwords for generic usage
function genpass() {
    CHARS='a-zA-Z0-9\n'
    COUNT=30
    if [ "$1" = '-h' ]; then CHARS='!-~\n'; shift; fi
    if [ -n "$1" -a "$1" -gt 5 -a "$1" -lt 200 ]; then COUNT="$1"; shift; fi
    tr -dc "${CHARS}" < /dev/urandom | grep '^.\{'"${COUNT}"'\}$' | head -n 10
}

##
## Import local file if present
##

if [ -r ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
