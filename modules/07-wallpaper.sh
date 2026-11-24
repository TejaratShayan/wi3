#!/usr/bin/env bash
# Wallpaper: feh + rofi picker (bin/wallpaper). Defaults to your Windows wallpaper.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install feh x11-xserver-utils

mkdir -p "$HOME/.local/bin" "$HOME/Pictures/wallpapers"
chmod +x "$ROOT/bin/wallpaper"
link_file "$ROOT/bin/wallpaper" "$HOME/.local/bin/wallpaper"

# First run: use the current Windows wallpaper as default
if [[ ! -s "$HOME/.config/wallpaper/current" ]]; then
  if DISPLAY= "$ROOT/bin/wallpaper" windows 2>/dev/null; then
    ok "Imported your Windows wallpaper as default"
  else
    warn "Couldn't import Windows wallpaper; put images in ~/Pictures/wallpapers"
  fi
fi

ok "Wallpaper ready. Alt+Shift+w to pick; images go in ~/Pictures/wallpapers"
