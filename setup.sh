#!/bin/sh

DOTFILES="$(realpath $(dirname $(which $0 2>/dev/null || echo $0)))"

for f in zshenv zshrc; do
    SRC="${DOTFILES}/${f}" 
    DST="${HOME}/.${f}"
    if [ -L "${DST}" -o ! -e "${DST}" ]; then
        ln -sf "${SRC}" "${DST}"
        echo "[OK] ${DST}"
    else
        echo "[!!] ${DST}: will not override"
    fi
done

