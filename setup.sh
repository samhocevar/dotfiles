#!/bin/sh

DOTFILES="$(realpath $(dirname $(which $0 2>/dev/null || echo $0)))"

case "$(uname)" in
    MINGW*|MSYS*)
        case "${MSYS}" in
            *winsymlinks*) ;;
            *) echo "Error: this MSYS2 system does not support symbolic links"
               echo "  uname: $(uname)"
               echo "  \$MSYS: ${MSYS}"
               exit 1 ;;
        esac
esac

for f in vimrc zshenv zshrc; do
    SRC="${DOTFILES}/${f}" 
    DST="${HOME}/.${f}"
    if [ -L "${DST}" -o ! -e "${DST}" ]; then
        ln -sf "${SRC}" "${DST}"
        echo "[OK] Installed ${DST} symlink"
    else
        echo "[!!] Cannot install ${DST}: file exists, will not overwrite"
    fi
done

