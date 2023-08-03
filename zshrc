# Copyright © 1999–2023 Sam Hocevar <sam@hocevar.net>
#
# This file is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# to Public License, Version 2, as published by the WTFPL Task Force.
# See http://www.wtfpl.net/ for more details.

# Handle LS_COLORS
if command -v dircolors >/dev/null; then
    for f in ~/.dir_colors /etc/dir_colors; do
        if [ -r "$f" ]; then
            eval "$(dircolors "$f")"
        fi
    fi
fi

# Handle PS_COLORS and TOP_COLORS (doesn't seem to work)
if command -v pscol >/dev/null; then
    eval "$(pscol)"
fi

# Default editor: neovim if available, otherwise vim
for f in nvim vim; do
    if command -v "$f" >/dev/null; then
        export VISUAL="$f"
        export EDITOR="$f"
        break
    fi
done

# Force emacs mode (to bypass ex mode detection from $VISUAL)
bindkey -e

# Search in history, handle home, pgup etc.
bindkey '^[[1~' beginning-of-line       # Home
bindkey '^[[4~' end-of-line             # End
bindkey '^[[3~' delete-char             # Del
bindkey '^[[2~' overwrite-mode          # Insert
bindkey '^[[5~' history-search-backward # PgUp
bindkey '^[[6~' history-search-forward  # PgDn

# Better ls and grep on foreign systems
case "$UNAME" in
    *BSD|SunOS)
        if command -v gnuls >/dev/null; then
            alias ls='gnuls --classify --tabsize=0 --literal --color=auto'
        fi
        ;;
    *)
        alias ls='ls --classify --tabsize=0 --literal --color=auto'
        alias grep='grep --color=auto'
        alias rgrep='rgrep --color=auto'
        ;;
esac

# Do not accidentally clobber files
alias cp='nice -20 cp -i'
alias mv='nice -20 mv -i'
alias rm='nice -20 rm -i'
unsetopt clobber # Force >| instead of >

# Handy command to format man pages
mf(){
    tbl $* | nroff -mandoc | less -s
}

# Full black & white prompt
export PS1="%D{%d/%m} %T %n@%U%m%u %~%# "
export PS2="> "

# If inside a chroot, get /etc/hostname
if test "$(df / | awk 'END { print $1 }')" = "-" -a -f /etc/hostname; then
    HOST="$(< /etc/hostname)"
fi

# Full color prompt
export PS1="%{[36;1m%}%D{%d/%m}%{[0m%} %{[36;1m%}%T%{[0m%} %{[31;1m%}%n%{[0m[33;1m%}@%{[37;1m%}%m %{[32;1m%}%~%{[0m[33;1m%}
%#%{[0m%} "

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

# Completion
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

# History
setopt   append_history
setopt   bang_hist
setopt   csh_junkie_history
unsetopt extended_history
unsetopt hist_allow_clobber
unsetopt hist_beep
setopt   hist_ignore_dups
unsetopt hist_ignore_space
setopt   hist_no_store
setopt   hist_verify

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

# History handling
export HISTORY=256
export SAVEHIST=2048
export HISTSIZE=256
export HISTFILE=$HOME/.history
export MAIL=/var/mail/$USERNAME

# Completion
compctl -g '*(-/)' cd # allow links with '-'

#
# Windows-specific stuff (on MSYS2)
#

if [ "${OSTYPE}" = "msys" ]; then
    # Slightly better version of "start" which acts on files and relative paths
    start() {
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
    faketime() {
        date="$(date -d "$1")"
        shift
        GIT_AUTHOR_DATE="$date" GIT_COMMITER_DATE="$date" "$@"
    }
}

# Create a Go version tag from the current Git commit
git-go-version() {
    TZ=UTC git --no-pager show --quiet --abbrev=12 --date='format-local:%Y%m%d%H%M%S' --format="%cd-%h"
}

