# Dotfiles

Personal configs for a Hyprland-based Linux desktop.

## Installation

```
./install.sh
```

Symlinks the following configs into `~/.config`:

- **hypr** – Hyprland window manager config
- **quickshell** – status bar, Bluetooth widget and idle-lock screensaver
- **tmux** – terminal multiplexer config
- **alacritty** – terminal emulator config
- **nvim** – Neovim config based on [LazyVim](https://www.lazyvim.org/)

An existing real directory is removed first; an existing symlink is simply overwritten.
