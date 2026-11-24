#!/usr/bin/env bash
# Screenshot tool: maim + slop (quick), flameshot (annotate), rofi menu.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install maim slop xdotool xclip flameshot libnotify-bin feh

mkdir -p "$HOME/.local/bin" "$HOME/Pictures/screenshots"
chmod +x "$ROOT/bin/screenshot"
link_file "$ROOT/bin/screenshot" "$HOME/.local/bin/screenshot"

# flameshot rewrites its config itself (which would replace a symlink),
# so copy the defaults once instead of linking.
FS="$HOME/.config/flameshot/flameshot.ini"
if [[ ! -e $FS ]]; then
  mkdir -p "$(dirname "$FS")"
  { cat "$ROOT/config/flameshot/flameshot.ini"; echo "savePath=$HOME/Pictures/screenshots"; } > "$FS"
  ok "Wrote $FS"
else
  info "Keeping existing $FS"
fi

ok "Screenshots ready. Print = area, Alt+Shift+s = menu"
