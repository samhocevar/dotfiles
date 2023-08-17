# dotfiles

A collection of configuration files for vim, zsh, etc. that I carry around.

Nothing too fancy, but it’s made my life easier for the last 25 years.

## Installation

```sh
git clone https://github.com/samhocevar/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

The installation script will create symbolic links if possible. Otherwise, the
existing configuration files will be left untouched.

When using an MSYS2 system, symbolic links must be enabled through the `MSYS`
environment variable.

## Upgrades

Assuming you run Zsh:

```sh
update-dotfiles
```
