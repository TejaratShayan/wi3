#!/usr/bin/env bash
# Installs zsh as the login shell with plugins, starship prompt and CLI tools,
# and themes alacritty to match.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install zsh zsh-autosuggestions zsh-syntax-highlighting \
  starship fzf zoxide eza bat fonts-jetbrains-mono fonts-font-awesome

mkdir -p "$HOME/.cache"
link_file "$ROOT/config/zsh/.zshrc"               "$HOME/.zshrc"
link_file "$ROOT/config/starship/starship.toml"   "$HOME/.config/starship.toml"
link_file "$ROOT/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

ZSH_PATH="$(command -v zsh)"
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]]; then
  sudo chsh -s "$ZSH_PATH" "$USER"
  ok "Login shell changed to zsh (open a new WSL terminal to use it)"
else
  info "zsh is already the login shell"
fi

ok "zsh ready."
