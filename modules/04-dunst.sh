#!/usr/bin/env bash
# Installs dunst (notification daemon) themed like rofi/polybar,
# a rofi notification center and a polybar status module.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install dunst libnotify-bin python3

link_file "$ROOT/config/dunst" "$HOME/.config/dunst"

mkdir -p "$HOME/.local/bin"
for f in rofi-notifications polybar-notifications dunst-launch; do
  chmod +x "$ROOT/bin/$f"
  link_file "$ROOT/bin/$f" "$HOME/.local/bin/$f"
done

ok "dunst installed. Restart i3 (Alt+Shift+r), then test: notify-send 'Hello' 'It works'"
