##
## This file is managed globally by update-dotfiles and may be overwritten
## Local configuration should be stored in .zshenv.local
## See https://github.com/samhocevar/dotfiles for more information
##
## Copyright © 1998–2023 Sam Hocevar <sam@hocevar.net>
##
## This file is free software. It comes without any warranty, to
## the extent permitted by applicable law. You can redistribute it
## and/or modify it under the terms of the Do What The Fuck You Want
## to Public License, Version 2, as published by the WTFPL Task Force.
## See http://www.wtfpl.net/ for more details.
##

# Proper alphasort
# Nicer messages than C/POSIX (apostrophes etc.)
export LANG=en_GB.UTF-8
# Proper date and time
#export LC_TIME=fr_FR.UTF-8
export LC_TIME=en_GB.UTF-8
# Use EUR as the currency but “.” as the decimal point
export LC_MONETARY=en_IE.UTF-8
# A4 paper
export LC_PAPER=fr_FR.UTF-8

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# I want coredumps
unlimit coredumpsize

#
# Reasonable defaults for some software
#

# Perforce
if which p4 >/dev/null; then export P4CONFIG='.p4config'; fi
if which colordiff >/dev/null; then export P4DIFF='colordiff -uw'; fi
if which vim >/dev/null; then export P4EDITOR='vim'; fi

# Git
export FILTER_BRANCH_SQUELCH_WARNING=1

#
# Windows-specific stuff (on MSYS2)
#

if [ "${OSTYPE}" = "msys" ]; then
    # Since at least 2.39, Git for Windows behaves very well in MSYS2, there is
    # no reason to have the MSYS2 version which will have big performance issues
    # FIXME: improve the following test by checking that both are in $PATH
    #if [ -x "/c/Program Files/Git/bin/git.exe" -a -x "/usr/bin/git.exe" ]; then
    #    echo "Warning: Windows and MSYS Git were both found; for best performance,"
    #    echo "uninstall MSYS Git using: 'pacman -R git'"
    #fi

    # Avoid weird duplicates in the environment (leads to crashes in many .NET
    # programs because the environment is stored as a dictionary and duplicate
    # keys cause exceptions)
    unset temp && export temp
    unset tmp  && export tmp

    # Fix Ansible SSH connection issues (https://github.com/geerlingguy/JJG-Ansible-Windows/issues/6)
    ANSIBLE_SSH_ARGS='-o ControlMaster=no'
    export ANSIBLE_SSH_ARGS

    # Default to Unicode IO in Python
    PYTHONIOENCODING=utf-8
    export PYTHONIOENCODING
fi

##
## Import local file if present
##

if [ -r ~/.zshenv.local ]; then
    . ~/.zshenv.local
fi
