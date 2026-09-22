#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

COMMON_CONFIGS=(tmux nvim)
LINUX_CONFIGS=()
MACOS_CONFIGS=(fish ghostty)

case "$(uname -s)" in
  Darwin)
    CONFIGS=("${COMMON_CONFIGS[@]}" "${MACOS_CONFIGS[@]}")
    ;;
  Linux)
    CONFIGS=("${COMMON_CONFIGS[@]}" "${LINUX_CONFIGS[@]}")
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

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
