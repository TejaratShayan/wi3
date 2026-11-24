#!/usr/bin/env bash
# Installs rofi (app launcher / window switcher) with icons and a theme.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install rofi fonts-jetbrains-mono papirus-icon-theme

link_file "$ROOT/config/rofi" "$HOME/.config/rofi"

ok "rofi installed. In i3: Alt+d apps, Alt+Shift+d commands, Alt+Tab windows"

# "Run as root" launcher (sudo with rofi password prompt)
mkdir -p "$HOME/.local/bin"
for f in rofi-sudo rofi-askpass; do
  chmod +x "$ROOT/bin/$f"
  link_file "$ROOT/bin/$f" "$HOME/.local/bin/$f"
done
ok "Root launcher: Alt+Ctrl+d"
