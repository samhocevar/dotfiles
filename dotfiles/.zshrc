
alias getallphotos='for i in `seq 1 120` ; do photopc image $i pic`echo $i + 1000 | bc | cut -b 2-4`.jpeg ; done'
alias cvs_videolan='cvs -d :pserver:sam@cvs.videolan.org:/var/cvs/videolan'
alias cvs_cnedra='cvs -d :pserver:sam@cvs.via.ecp.fr:/var/cvs/cnedra'
alias cvs_sam='cvs -d :pserver:sam@cvs.via.ecp.fr:/var/cvs/sam'
alias cvs_gnome='cvs -d :pserver:anonymous@anoncvs.gnome.org:/cvs/gnome'
alias cvs_mjdrdm2='cvs -d :pserver:sam@cvs.nimp.org:/var/cvs/mjdrdm2'
alias cvs_quake='cvs -d:pserver:anonymous@cvs.quake.sourceforge.net:/cvsroot/quake'
alias cvs_galeon='cvs -d:pserver:anonymous@cvs.galeon.sourceforge.net:/cvsroot/galeon'
alias cvs_dacode='cvs -d:pserver:anonymous@cvs.dacode.sourceforge.net:/cvsroot/dacode'
alias cvs_berlin='cvs -d:pserver:anonymous@cvs.berlin.sourceforge.net:/cvsroot/berlin'
alias cvs_livid='cvs -d:pserver:anonymous@cvs.linuxvideo.org:/cvs/livid'

debupload () { scp $* sho@auric.debian.org:/org/ftp.debian.org/incoming }
debupload-nonus () { scp $* sho@pandora.debian.org:/org/non-us.debian.org/incoming }

# big-endian hexdump
hex () { hexdump $* | sed 's/ \(..\)\(..\)/\2\1/g' | cut -b 8-80 }

# quick alias
alias dpkg-builddirtypackage='chmod +x debian/rules && dpkg-buildpackage -rfakeroot -us -uc'

rwget () { wget --header "Referer: $1" $* }

ipcflush () {
  IPCS="`ipcs | awk '{ if ($6 == 0) print $2 }'`"
  echo -n "ipcflush: "
  test "$IPCS" && ipcrm shm `echo $IPCS` || echo "nothing to flush."
}

mid() { (echo "mode reader" ; echo "article <$*>" | sed 's/%40/@/ ; s/%24/\$/g ; s/<<*/</g ; s/>>*/>/g' ) | tee /dev/stderr | nc news 119 | tail +3 }

pingwait () {
  until fping -q $* 2>/dev/null 2>&1
  do
    sleep 5
  done
}

alias mixlines='awk ''{ printf "%s %i\n", $0, NR }''|rev|tr 0-9azertyuiop azertyuiop0-9|sort|cut -f2- -d'' ''|tr 0-9azertyuiop azertyuiop0-9|rev'

alias sms='links ''http://www.genie.fr/login.jsp?Action=sms'''

volinc() { for i in `seq $1 $2` ; do aumix -v $i ; sleep $3 ; done }

#alias cmake-cleanvlc='cmake distclean && ./configure --enable-gnome --enable-kde --enable-qt --enable-debug --enable-dvdcss && cmake'
alias cmake-cleanvlc='cmake distclean && ./configure --enable-gnome --enable-dvdread --enable-mga --with-mad --enable-debug && cmake'

customseq() { i=$1 ; while test $i -lt `expr $2 + 1` ; do echo $i ; i=`expr $i + 1` ; done }

if [ -r ~/.ssh/known_hosts ]
then
  hosts=(`sed 's/^\([[:alnum:]\.]*\).*/\1/' < ~/.ssh/known_hosts`)
  compctl -k hosts -x 'c[-1,-l]' -u -- + -x 'm[2,2]' -u -S "@" -- + -x 'n[1,@]' -k hosts -- ssh
  compctl -f + -k hosts -S ":" + -u -S "@" -x 'n[1,@]' -k hosts -S ":" -- scp
fi

noproxy() { unset http_proxy; unset ftp_proxy }

sncf() { export http_proxy="http://proxy.dr.sncf.fr:8080/" ftp_proxy="http://proxy.dr.sncf.fr:8080/"; export no_proxy="dr.sncf.fr,sncf.fr" }
#sncf() { export http_proxy="http://10.13.200.19:8080/" ftp_proxy="ftp://10.13.200.19:21/"; export no_proxy="dr.sncf.fr,sncf.fr" }
localproxy() { export http_proxy="http://localhost:8080/" ftp_proxy="http://localhost:8080/"; export no_proxy="dr.sncf.fr,sncf.fr" }

ssh-8888() { while : ; do ssh 0 $* -C -p 8888 -v ; done }
ssh-9999() { while : ; do ssh 0 $* -C -p 9999 -v ; done }

setcvshost() {
  test -d CVS \
    && (find -name Root | while read i ; do \
            sed 's/@[^:]*:/@'"$1"':/' < "$i" >| "$i.bak" ; \
            mv -f "$i.bak" "$i" ; done) \
    || (echo "not in a CVS directory" && false)
}

setsvnroot() {(
  if [ ! -f .svn/entries ]; then
    echo "$0: not in a SVN repository"
    return 1
  fi
  while [ -f ../.svn/entries ]; do
    cd ..
    echo "$0: climbing up to "'`'"`pwd`' ..."
  done
  ROOT="`sed -ne 's%.*url="\([^"]*\)".*%\1%p' < .svn/entries`"
  case "$ROOT" in
    file:///*)
      PROTO="file"
      LOGIN=""
      REPOS="`echo "$ROOT" | cut -b8-`"
      ;;
    svn://*/*)
      PROTO="svn"
      LOGIN="`echo "$ROOT" | cut -f3 -d/`"
      REPOS="/`echo "$ROOT" | cut -f4- -d/`"
      ;;
    svn+ssh://*/*)
      PROTO="svn+ssh"
      LOGIN="`echo "$ROOT" | cut -f3 -d/`"
      REPOS="/`echo "$ROOT" | cut -f4- -d/`"
      ;;
    *)
      echo "$0: unrecognised root -- $ROOT"
      return 1
      ;;
  esac
  NEWPROTO=""
  NEWLOGIN=""
  NEWREPOS=""
  while test $# -gt 0; do
    case "$1" in
      -p) NEWPROTO="$2"; ;;
      -h) NEWLOGIN="$2"; ;;
      -r) NEWREPOS="$2"; ;;
      *) echo "$0: unknown option -- $1"; INVALID=yes; break; ;;
    esac
    if [ $# = 1 ]; then
      echo "$0: missing argument -- $1"
      return 1
    fi
    shift
    shift
  done
  if [ -z "$NEWPROTO" -a -z "$NEWLOGIN" -a -z "$NEWREPOS" ] || [ -n "$INVALID" ]; then
    echo "Usage:"
    echo "  $0 [-p proto] [-h host] [-r repository]"
    echo "Examples:"
    echo "  $0 -h foo@svn.domain.com"
    echo "  $0 -p svn -h svn.domain.com -r /var/svn/module"
    echo "  $0 -p svn+ssh -h svn.domain.com -r /var/svn/module"
    echo "  $0 -p file"
    echo "Current root:"
    echo "  $ROOT"
    return 1
  fi
  # test the protocol validity
  case "$NEWPROTO" in
    file)
      if [ -n "$NEWLOGIN" ]; then
        echo "$0: cannot specify -h with file://"
        return 1
      fi
      if [ -z "$NEWREPOS" ]; then NEWREPOS="$REPOS"; fi
      ;;
    svn+ssh|svn)
      if [ -z "$NEWLOGIN" -a -z "$LOGIN" ]; then
        echo "$0: -h is needed to change protocol to svn+ssh/svn"
        return 1
      fi
      if [ -z "$NEWLOGIN" ]; then NEWLOGIN="$LOGIN"; fi
      if [ -z "$NEWREPOS" ]; then NEWREPOS="$REPOS"; fi
      ;;
    "")
      if [ -n "$NEWLOGIN" -a "$PROTO" = "file" ]; then
        NEWPROTO="svn+ssh"
      else
        NEWPROTO="$PROTO"
      fi
      if [ -z "$NEWLOGIN" ]; then NEWLOGIN="$LOGIN"; fi
      if [ -z "$NEWREPOS" ]; then NEWREPOS="$REPOS"; fi
      ;;
    *)
      echo "$0: unknown protocol -- $NEWPROTO"
      return 1
      ;;
  esac
  case "$NEWREPOS" in
    /*)
      ;;
    *)
      echo "$0: repository must start with /"
      return 1
      ;;
  esac
  # do the job
  echo "$0: changing url to $NEWPROTO://$NEWLOGIN$NEWREPOS"
  find -name entries | while read i;
    do sed -e 's%\(url\|repos\)="'"$ROOT"'%\1="'"$NEWPROTO://$NEWLOGIN$NEWREPOS"'%' < "$i" >| "$i.bak"
    mv -f "$i.bak" "$i"
  done
  echo "done."
)}

compctl -g '*.ps' + -g '*' ggv

getallimages() {
   _getallimages_inner "href" "$@"
}

getallembed() {
   _getallimages_inner "src" "$@"
}

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

getbug_debian() {
    wget 'http://bugs.debian.org/cgi-bin/bugreport.cgi?archive=no&bug='"$1" -O "$1"'.html'
}

getbugs() {
    wget -O - 'http://bugzilla.videolan.org/cgi-bin/bugzilla/buglist.cgi?short_desc_type=allwordssubstr&short_desc=&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&changedin=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&newqueryname=&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0='
}

getlongbugs() {
    wget -O - 'http://bugzilla.videolan.org/cgi-bin/bugzilla/long_list.cgi?buglist='`getbugs | grep 'hidden.*buglist' | cut -f6 -d'"' | tr , '\n' | sort -n | tr '\n' ,`
}

rdesktop-c18() { rdesktop -K -D -k fr -g 1024x768 $* }
rdesktop-cinoptik() { rdesktop -K -D -k fr -g 1400x1050 testcinoptik }
rdesktop-uniways() { rdesktop -K -D -k en-us -g 1400x1050 192.168.11.12 }
rdesktop-uniways-proxychains() { proxychains rdesktop -K -D -k en-us -g 1400x1050 192.168.11.12 }

#if [ -x "/usr/bin/dchroot" ]; then
#  dchroot() {
#    if [ -z "$*" ]; then
#      echo "usage: dchroot [ sid | woody | potato | rh72 | mdk82 ]"
#      return 1
#    fi
#    /usr/bin/dchroot -d -c $* }
#fi

#leetzorize() {
#   tr 'a-zA-Z' '

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

apt-rbdepends () { grep-dctrl -F Build-Depends "$1" -s Maintainer,Package /var/lib/apt/lists/*_Sources }

#export PS1="%{[36;1m%}%D{%d/%m}%{[0m%} %{[36;1m%}%T%{[0m%} %{[31;1m%}%n%{[0m[33;1m%}@%{[37;1m%}%m %{[32;1m%}"'`echo "$PWD"|sed "s/^\(.\{20\}\).*\(.\{20\}\)$/\1...\2/"`'"%{[0m[33;1m%}%#%{[0m%} "

clean-build-areas() {
  df ~
  rm -Rf ~/debian/pkg-*/*/build-area/[a-z]*
  rm -Rf ~/debian/pkg-*/*/*/build-area/[a-z]*
  df ~ | tail -1
}

alias export-quilt-patches='export QUILT_PATCHES=debian/patches'
alias rgrep='rgrep --color=auto --exclude "*.svn-base" --exclude "tempfile.tmp"'
alias grep='grep --color=auto'

alias btdownloadcurses='btdownloadcurses --max_upload_rate 20'
alias dchroot='schroot -pc'

alias 1400x1050='wmres 1400 1050 84960'
alias 640x480='wmres 640 480 84960'

mia-query() {
  ssh merkel.debian.org /org/qa.debian.org/mia/mia-query "$@"
}

ozymanssh() {
  ssh -C -o ProxyCommand="~/ozyman/droute.pl sshdns.newstx.zoy.org" sam@poulet.zoy.org
}

playflv() {
  WOOT="$(wget -qO- "$1" | sed -ne 's/.*[="]\(http[^ "]*\.flv\).*/\1/p' | head -1)"
  echo "Playing $WOOT"
  vlc -q -I dummy "$WOOT"
}

flv-dl() {
  WOOT="$(wget -qO- "$1" | sed -ne 's/.*[="]\(http[^ "]*\.flv\).*/\1/p' | head -1)"
  wget "$WOOT"
}

#alias telnet='telnet-auto'
alias xboard='xboard -size medium'

alias adrift='cd ~/adrift/UnrealEngine3/Development/Src/ExampleGame'
alias ida='wine ~/.wine/drive_c/Program\ Files/IDA/idag64.exe'

alias make_package_npdrm="${CELL_SDK}/host-win32/bin/make_package_npdrm.exe"
alias make_edata_npdrm="${CELL_SDK}/host-win32/bin/make_edata_npdrm.exe"

alias chromium="chromium -incognito --ignore-gpu-blacklist"
alias google-chrome="google-chrome -incognito --ignore-gpu-blacklist"
alias bc="bc -l"

alias recordmydesktop="recordmydesktop --no-sound"

dromat() {
 cat $1 | sed 's/^  *//; s/  *$//' | tr -d '\n' | sed 's/##/¡/g'  | tr ¡ '\n'|grep ...|sed 's/.*AP]//' | grep -v '#\(Trivia\|gnaa\|linuxfr\|debian-fr\|wiki\|linuxchix\|chatons-rouge\|libcaca\|zoy\|poetry\|[sS]ex\|feminismes\|chat\)\>' | grep -v HTTP/1.1
}

raspi-install () {
    for pkg in "$@"
    do
        apt-get download "$pkg":armhf \
         && dpkg-deb -x "$pkg"_*.deb $RASPI_SDK_ROOT/chroot \
         && rm -f "$pkg"_*_armhf.deb
    done
}

genpass() {
    tr -dc '[!-~]\n' < /dev/urandom | grep '^.\{12,20\}$'
}

distcc-make() {(
    export PATH="/usr/lib/distcc:$PATH"
    make $*
)}

mtgox() {
  while sleep 1 ; do (date; wget https://mtgox.com/trade -qO- | sed -ne '/\(Last\|High\|Low\|Volume\)/s/<[^>]*>/ /gp') | xargs; done | uniq -f 7
}

cookie_f()
{
    CLICK100="`yes click 1 sleep 0.001 | head -n 100`"
    while : ; do xdotool `echo "$CLICK100"`; done
}
cookie_t() { yes $2 | head -n $1 }
cookie_m() { for x in $*; do echo click 1 mousemove_relative --polar $x 15 sleep 0.001; done }

grandma()
{
    CMD="`cookie_m $(for x in $(seq 15); do cookie_t 10 165; cookie_t 10 15; done);
          cookie_m $(for x in $(seq 15); do cookie_t 10 345; cookie_t 10 195; done)`"
    CLICK100="`yes click 1 sleep 0.002 | head -n 100`"
    while : ; do
        #xdotool mousemove 385 360
        xdotool mousemove 295 360
        xdotool `echo $CMD`
        #xdotool mousemove 385 360
        xdotool mousemove 295 360
        for x in `seq 10`; do xdotool `echo "$CLICK100"`; done
        sleep 1
    done
}

function fuck() {
  if killall -9 "$2"; then
    echo
    echo " (╯°□°）╯︵$(echo "$2"|toilet -f term -F rotate)"
    echo
  fi
}

c64_f()
{
    CLICK100="`yes click 1 sleep 0.08 | head -n 100`"
    while : ; do xdotool `echo "$CLICK100"`; done
}

steam-win32()
{
    export WINEDEBUG=-all
    nice -n 19 wine "C:/Program Files/Steam/Steam.exe" -no-dwrite
    #wine "$HOME/.wine/drive_c/Program Files/Steam/Steam.exe"
}

