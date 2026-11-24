#!/usr/bin/env bash
# Installs polybar (status bar) themed like rofi, replacing i3bar.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install polybar curl iproute2 iso-codes python3 fonts-font-awesome fonts-jetbrains-mono psmisc x11-xserver-utils

link_file "$ROOT/config/polybar" "$HOME/.config/polybar"

mkdir -p "$HOME/.local/bin"
for f in polybar-launch rofi-powermenu polybar-ipcountry vpn; do
  chmod +x "$ROOT/bin/$f"
  link_file "$ROOT/bin/$f" "$HOME/.local/bin/$f"
done

fc-cache -f >/dev/null
ok "polybar installed. Restart i3 (Alt+Shift+r) to see it."
