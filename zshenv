# Copyright © 1998—2016 Sam Hocevar <sam@hocevar.net>
# This file is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# to Public License, Version 2, as published by the WTFPL Task Force.
# See http://www.wtfpl.net/ for more details.

export GNOME_DISABLE_CRASH_DIALOG=1
export KDE_DEBUG=1

# Debian stuff
export EMAIL='sho@debian.org'
export DEBEMAIL='sho@debian.org'
export DEBFULLNAME='Sam Hocevar'
export DEB_SIGN_KEYID=0xfffffffe
export DEBSIGN_KEYID=0xfffffffe # for debsign
export DEB_BUILD_OPTIONS="$DEB_BUILD_OPTIONS parallel=4"

# Proper alphasort
# Nicer messages than C/POSIX (apostrophes etc.)
export LANG=en_GB.UTF-8
# Proper date and time
#export LC_TIME=fr_FR.UTF-8
export LC_TIME=en_GB.UTF-8
# Use EUR as the currency
# Use "." as the decimal point
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

# Perforce
export P4CONFIG=.p4config
if command -w colordiff >/dev/null; then
    export P4DIFF="colordiff -uw"
fi

# PS3 programming
if [ -d "$HOME/ps3/cell" ]; then
    export CELLSDK="$HOME/ps3/cell"
    export CELL_SDK="$CELLSDK"
    export SCE_PS3_ROOT="$CELLSDK"
    export PATH="$PATH:$CELLSDK/host-linux/bin"
    export PATH="$PATH:$CELLSDK/host-linux/ppu/bin"
    export PATH="$PATH:$CELLSDK/host-linux/spu/bin"
fi

# Android programming
if [ -d "$HOME/android/sdk" ]; then
    export PATH="$PATH:$HOME/android/sdk/tools"
    export PATH="$PATH:$HOME/android/sdk/platform-tools"
    export ANDROID_NDK_ROOT="$HOME/android/ndk"
    export PATH="$PATH:$ANDROID_NDK_ROOT"
    export ANDROID_NDK_ARM_TOOLCHAIN="$HOME/android/arm-linux-androideabi"
    export PATH="$PATH:$ANDROID_NDK_ARM_TOOLCHAIN/bin"
fi

# NaCl programming
if [ -d "$HOME/nacl_sdk" ]; then
    export NACL_SDK_ROOT="$HOME/nacl_sdk"
    export PATH="$PATH:$NACL_SDK_ROOT/pepper_26/toolchain/linux_x86_newlib/bin"
fi

# RasPi programming
if [ -d "$HOME/raspi" ]; then
    export RASPI_SDK_ROOT="$HOME/raspi"
    export PATH="$PATH:$RASPI_SDK_ROOT/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/bin"
fi

# More PATH stuff
if [ -d "$HOME/emscripten" ]; then
    export PATH="$HOME/emscripten:$PATH"
fi
if [ -d "$HOME/neovim" ]; then
    export PATH="$PATH:$HOME/neovim/build/bin"
fi

# I want coredumps
unlimit coredumpsize

