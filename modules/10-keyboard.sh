#!/usr/bin/env bash
# Persian + English typing in i3 via the fcitx5 input method.
# (Xephyr ignores X keymap changes, so setxkbmap can't add Persian there;
#  an input method works independently of the X keymap.)
# Switch: Alt+Shift (pressed and released alone), both Shifts, or click EN/FA on polybar.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install fcitx5 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 \
  fcitx5-frontend-qt5 fcitx5-frontend-qt6 fcitx5-config-qt fonts-vazirmatn

# fcitx5 rewrites its config files, so copy the defaults once (don't symlink)
mkdir -p "$HOME/.config/fcitx5"
for f in profile config; do
  if [[ ! -e "$HOME/.config/fcitx5/$f" ]]; then
    cp "$ROOT/config/fcitx5/$f" "$HOME/.config/fcitx5/$f"; ok "Wrote ~/.config/fcitx5/$f"
  else
    info "Keeping existing ~/.config/fcitx5/$f"
  fi
done

mkdir -p "$HOME/.local/bin"
for f in fcitx5-launch polybar-kblayout; do
  chmod +x "$ROOT/bin/$f"; link_file "$ROOT/bin/$f" "$HOME/.local/bin/$f"
done
fc-cache -f >/dev/null

ok "Persian/English ready. Restart your i3 instances (start-i3) to activate."
