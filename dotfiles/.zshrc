# Copyright © 1998—2016 Sam Hocevar <sam@hocevar.net>
# This file is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# to Public License, Version 2, as published by the WTFPL Task Force.
# See http://www.wtfpl.net/ for more details.

# Completion for ggv
compctl -g '*.ps' + -g '*' ggv

debupload() { scp $* sho@auric.debian.org:/org/ftp.debian.org/incoming }
debupload-nonus() { scp $* sho@pandora.debian.org:/org/non-us.debian.org/incoming }

# big-endian hexdump
hex() { hexdump $* | sed 's/ \(..\)\(..\)/\2\1/g' | cut -b 8-80 }

# quick alias
alias dpkg-builddirtypackage='chmod +x debian/rules && dpkg-buildpackage -rfakeroot -us -uc'

mid() { (echo "mode reader" ; echo "article <$*>" | sed 's/%40/@/ ; s/%24/\$/g ; s/<<*/</g ; s/>>*/>/g' ) | tee /dev/stderr | nc news 119 | tail +3 }

# Completion for ssh hosts
if [ -r "$HOME/.ssh/known_hosts" ]; then
    hosts=($(sed 's/^\([[:alnum:]\.]*\).*/\1/' < "$HOME/.ssh/known_hosts"))
    compctl -k hosts -x 'c[-1,-l]' -u -- + -x 'm[2,2]' -u -S "@" -- + -x 'n[1,@]' -k hosts -- ssh
    compctl -f + -k hosts -S ":" + -u -S "@" -x 'n[1,@]' -k hosts -S ":" -- scp
fi

getallimages() { _getallimages_inner "href" "$@" }
getallembed() { _getallimages_inner "src" "$@" }

_getallimages_inner() {
  TAG="$1"
  shift
  while test "$#" -gt 0; do
    URL="$1"
    DIR=`echo "$URL" | sed 's/[^a-zA-Z0-9_.-]/-/g'`
    PREFIX=`echo "$1" | sed 's/?.*//' | sed 's@^\(.*/\).[^/]*$@\1@'`
    ROOT=`echo "$1" | sed 's@\(://[^/]*\)/.*$@\1@'`
    mkdir -p "$DIR"
    ( cd "$DIR"
      wget --cache=no -O - -U 'Mozilla/5.0' "$URL" | tr '>' '\n' | grep -i "$TAG" | sed 's/.*'"$TAG"' *=[ "]*//i ; s/[" ].*//g' | grep -i '\(jpe\|jpg\|jpeg\|gif\|png\|mpg\|mpeg\|avi\|wmv\)$' | grep -v '/src[.]cgi/' | sort | uniq | while read IMAGE
      do
        if echo "$IMAGE" | grep -qi "^//"; then IMAGE="http:$IMAGE"; fi
        if echo "$IMAGE" | grep -qi "^/"; then IMAGE="$ROOT/$IMAGE"; fi
        if echo "$IMAGE" | grep -vqi "^http"; then IMAGE="$PREFIX/$IMAGE"; fi
        echo "$IMAGE"
        wget -c -U 'Mozilla/5.0' --header "Referer: $URL" "$IMAGE" 2>&1 | grep '\(\[\|fully retrieved\)'
      done
    ) # cd ..
    shift
  done
}

# ispic(): checks whether a binary object, either a .o or a .so file, has
# only PIC code in it. It can also inspect .o files within a .a archive.
# Written by Sam Hocevar <sam@zoy.org> 2004/10/28
hasxstack() {
   hasxstack_internal() {
      STACK="`objdump --headers --private-headers -T "$1" | grep -A1 STACK | sed -ne 's/.*flags //p'`"
      case "$STACK" in
      *x) echo -e "$2"': \x1b[31;1mhas executable stack ('"$STACK"')\x1b[0m' ;;
      *) echo -e "$2"': \x1b[32;1mstack is OK ('"$STACK"')\x1b[0m' ;;
      esac
   }
   for x in $*; do
      TMPFILE="`tempfile -s .so`"
      case "$x" in
         *.a)
            echo "$x: archive"
            TMPOFILE="`tempfile -s .o`"
            for o in `ar t "$x"`; do
               ar p "$x" "$o" >| "$TMPOFILE"
               hasxstack "$TMPOFILE" | sed 's .*: \ \ '"$o"': '
            done
            rm -f "$TMPOFILE"
            ;;
         *.o|*.so|*.so.*)
            case "$x" in
               *.so|*.so.*)
                  hasxstack_internal "$x" "$x"
                  ;;
               *.o)
                  if gcc "$x" -shared -o "$TMPFILE" 2>&1 | grep -q relocation; then
                     echo -e "$x"': \x1b[31;1mbad reloc, cannot check stack\x1b[0m'
                  else
                     hasxstack_internal "$TMPFILE" "$x"
                  fi
                  ;;
            esac
            ;;
      esac
      rm -f "$TMPFILE"
   done
}

ispic() {
   ispic_internal() {
      if objdump --headers --private-headers -T "$1" | grep -q TEXTREL; then
         echo -e "$2"': \x1b[31;1mhas non-PIC code\x1b[0m'
      else
         echo -e "$2"': \x1b[32;1mPIC\x1b[0m'
      fi
   }
   for x in $*; do
      TMPFILE="`tempfile -s .so`"
      case "$x" in
         *.a)
            echo "$x: archive"
            TMPOFILE="`tempfile -s .o`"
            for o in `ar t "$x"`; do
               ar p "$x" "$o" >| "$TMPOFILE"
               ispic "$TMPOFILE" | sed 's .*: \ \ '"$o"': '
            done
            rm -f "$TMPOFILE"
            ;;
         *.o|*.so|*.so.*)
            case "$x" in
               *.so|*.so.*)
                  ispic_internal "$x" "$x"
                  ;;
               *.o)
                  if gcc "$x" -shared -o "$TMPFILE" 2>&1 | grep -q relocation; then
                     echo -e "$x"': \x1b[31;1mbad reloc, non-PIC code\x1b[0m'
                  else
                     ispic_internal "$TMPFILE" "$x"
                  fi
                  ;;
            esac
            ;;
      esac
      rm -f "$TMPFILE"
   done
}

alias wget='wget --no-check-certificate -U Mozilla/5.0'

apt-rbdepends() { grep-dctrl -F Build-Depends "$1" -s Maintainer,Package /var/lib/apt/lists/*_Sources }

clean-build-areas() {
    df ~
    rm -Rf ~/debian/pkg-*/*/build-area/[a-z]*
    rm -Rf ~/debian/pkg-*/*/*/build-area/[a-z]*
    df ~ | tail -1
}

alias export-quilt-patches='export QUILT_PATCHES=debian/patches'

alias make_package_npdrm="${CELL_SDK}/host-win32/bin/make_package_npdrm.exe"
alias make_edata_npdrm="${CELL_SDK}/host-win32/bin/make_edata_npdrm.exe"

alias chromium="chromium -incognito --ignore-gpu-blacklist"
alias google-chrome="google-chrome -incognito --ignore-gpu-blacklist"
alias bc="bc -l"

alias recordmydesktop="recordmydesktop --no-sound"

raspi-install() {
    for pkg in "$@"
    do
        apt-get download "$pkg":armhf \
         && dpkg-deb -x "$pkg"_*.deb $RASPI_SDK_ROOT/chroot \
         && rm -f "$pkg"_*_armhf.deb
    done
}

genpass() {
    tr -dc 'a-zA-Z0-9\n' < /dev/urandom | grep '^.\{12,30\}$' | head -n 20
}

genpass-hard() {
    tr -dc '!-~\n' < /dev/urandom | grep '^.\{12,30\}$' | head -n 20
}

distcc-make() {(
    export PATH="/usr/lib/distcc:$PATH"
    make $*
)}

function fuck() {
    if killall -9 "$2"; then
        echo
        echo " (╯°□°）╯︵$(echo "$2"|toilet -f term -F rotate)"
        echo
    fi
}

steam-win32() {
    export WINEDEBUG=-all
    nice -n 19 wine "C:/Program Files/Steam/Steam.exe" -no-dwrite
    #wine "$HOME/.wine/drive_c/Program Files/Steam/Steam.exe"
}

