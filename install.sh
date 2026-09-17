#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

CONFIGS=(hypr quickshell tmux alacritty ghostty nvim herdr noctalia)

for name in "${CONFIGS[@]}"; do
    src="$DOTFILES_DIR/$name"
    dst="$CONFIG_DIR/$name"

    if [ -d "$dst" ] && [ ! -L "$dst" ]; then
        rm -rf "$dst"
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "Skipped $dst (already exists)"
        continue
    fi

    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
done
