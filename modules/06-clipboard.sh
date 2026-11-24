#!/usr/bin/env bash
# Two-way clipboard bridge between i3 (Xephyr) and Windows (via WSLg :0).
# start-i3 launches it automatically.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install xclip python3 python3-xlib

mkdir -p "$HOME/.local/bin"
chmod +x "$ROOT/bin/clip-bridge"
link_file "$ROOT/bin/clip-bridge" "$HOME/.local/bin/clip-bridge"

ok "Clipboard bridge installed. Restart start-i3 to activate it."
