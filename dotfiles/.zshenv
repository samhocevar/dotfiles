#export http_proxy="http://tigre.cti.ecp.fr:80/"
#export http_proxy="http://proxy.dr.sncf.fr:8080/"
#export no_proxy="ecp.fr,videolan.org"
#export PATH=$PATH:/opt/intel/compiler50/ia32/bin/
export PATH=$PATH:/usr/local/mas/bin/
export PATH=$PATH:/opt/mingw32ce/bin
export GNOME_DISABLE_CRASH_DIALOG=1
export KDE_DEBUG=1
#export DVDCSS_CACHE=~/.dvdcss
export MOZILLA_FIVE_HOME=/usr/lib/xulrunner

# mail Debian
export EMAIL='sho@debian.org'
export DEBEMAIL='sho@debian.org'
export DEBFULLNAME='Sam Hocevar'
export DEB_SIGN_KEYID=0xfffffffe
export DEBSIGN_KEYID=0xfffffffe # for debsign

export PATH="$PATH:$HOME/psp/pspdev/bin"
export PATH="$PATH:$HOME/apitrace"

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
export P4DIFF="colordiff -uw"

# PS3 programming
export CELLSDK=~/ps3/cell
export CELL_SDK=$CELLSDK
export SCE_PS3_ROOT=$CELLSDK
export PATH=$PATH:$CELLSDK/host-linux/bin
export PATH=$PATH:$CELLSDK/host-linux/ppu/bin
export PATH=$PATH:$CELLSDK/host-linux/spu/bin

# Android programming
export PATH="$PATH:$HOME/android/sdk/tools"
export PATH="$PATH:$HOME/android/sdk/platform-tools"
export ANDROID_NDK_ROOT="$HOME/android/ndk"
export PATH="$PATH:$ANDROID_NDK_ROOT"
export ANDROID_NDK_ARM_TOOLCHAIN="$HOME/android/arm-linux-androideabi"
export PATH="$PATH:$ANDROID_NDK_ARM_TOOLCHAIN/bin"

# NaCl programming
export NACL_SDK_ROOT="$HOME/nacl_sdk"
export PATH="$PATH:$NACL_SDK_ROOT/pepper_26/toolchain/linux_x86_newlib/bin"

# RasPi programming
export RASPI_SDK_ROOT="$HOME/raspi"
export PATH="$PATH:$RASPI_SDK_ROOT/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/bin"

# More PATH stuff
export PATH="$HOME/emscripten:$PATH"
export PATH="$PATH:$HOME/neovim/build/bin"

# I want coredumps
unlimit coredumpsize

# Debian stuff
export DEB_BUILD_OPTIONS="$DEB_BUILD_OPTIONS parallel=4"

# Fucking Sixaxis driver
export SDL_JOYSTICK_DEVICE=/dev/input/js2

# distcc stuff, for home use
export DISTCC_HOSTS='192.168.0.4,lzo'
