#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

COMMON_CONFIGS=(tmux nvim)
LINUX_CONFIGS=()
MACOS_CONFIGS=(fish ghostty)

link_config() {
  local src="$1"
  local dst="$2"

  if [ -d "$dst" ] && [ ! -L "$dst" ]; then
    rm -rf "$dst"
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "Skipped $dst (already exists)"
    return
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

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
  link_config "$DOTFILES_DIR/$name" "$CONFIG_DIR/$name"
done

# Hammerspoon insists on ~/.hammerspoon, so it can't live in $CONFIG_DIR.
if [ "$(uname -s)" = "Darwin" ]; then
  link_config "$DOTFILES_DIR/hammerspoon" "$HOME/.hammerspoon"
fi

link_config "$DOTFILES_DIR/golangci.yml" "$HOME/.golangci.yml"
