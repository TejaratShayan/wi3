#!/usr/bin/env bash
# GPU acceleration for apps inside i3 (WSL D3D12 bridge) + WebGL in Chrome.
#  - start-i3 sets GALLIUM_DRIVER=d3d12 (Mesa otherwise picks llvmpipe = CPU)
#  - Chrome is started with --use-angle=gl-egl (works with and without GLX)
#    via ~/.local/bin/google-chrome and per-user copies of its .desktop files.
# Re-run after Chrome updates its .desktop files.
set -euo pipefail
source "$ROOT/lib/common.sh"

apt_install mesa-utils libgl1-mesa-dri libegl-mesa0

if [[ -e /dev/dxg && -e /usr/lib/wsl/lib/libd3d12.so ]]; then
  r="$(DISPLAY="${DISPLAY:-:0}" GALLIUM_DRIVER=d3d12 timeout 10 glxinfo -B 2>/dev/null | sed -n 's/.*OpenGL renderer string: //p')"
  [[ -n $r ]] && ok "GPU via D3D12: $r" || warn "Couldn't confirm the D3D12 renderer (no display?)"
else
  warn "WSL GPU bridge (/dev/dxg, libd3d12) not found; apps will use software rendering"
fi

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
chmod +x "$ROOT/bin/google-chrome"
link_file "$ROOT/bin/google-chrome" "$HOME/.local/bin/google-chrome"

# Desktop entries (rofi, xdg-open) call /usr/bin/google-chrome-stable directly;
# make per-user copies that call the wrapper instead.
for f in google-chrome.desktop com.google.Chrome.desktop; do
  src="/usr/share/applications/$f"; dst="$HOME/.local/share/applications/$f"
  [[ -r $src ]] || continue
  sed "s#/usr/bin/google-chrome-stable#$HOME/.local/bin/google-chrome#g" "$src" > "$dst"
  info "Wrote $dst"
done
command -v update-desktop-database >/dev/null && update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

ok "Restart i3 (start-i3) and quit Chrome completely; then check chrome://gpu"
