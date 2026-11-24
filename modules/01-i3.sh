#!/usr/bin/env bash
# Installs i3 + Xephyr (nested X server for WSLg) and links the config.
set -euo pipefail
source "$ROOT/lib/common.sh"

info "Updating apt index"
sudo apt-get update -y

apt_install \
  i3-wm i3status i3lock dmenu \
  xserver-xephyr x11-xserver-utils x11-utils xinit dbus-x11 \
  xterm alacritty python3 python3-xlib \
  fonts-dejavu-core

# GPU access (removes "libEGL: failed to open /dev/dri/card0" warnings)
for g in video render; do
  if getent group "$g" >/dev/null && ! id -nG "$USER" | grep -qw "$g"; then
    sudo usermod -aG "$g" "$USER"
    warn "Added $USER to group '$g' (takes effect after: wsl --shutdown)"
  fi
done

link_file "$ROOT/config/i3/config" "$HOME/.config/i3/config"

mkdir -p "$HOME/.local/bin"
for f in start-i3 x-place-window xephyr-fullscreen i3-switch-instance; do
  chmod +x "$ROOT/bin/$f"
  link_file "$ROOT/bin/$f" "$HOME/.local/bin/$f"
done

if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  info "Added ~/.local/bin to PATH in ~/.bashrc"
fi

ok "i3 installed. Start it with: start-i3"
