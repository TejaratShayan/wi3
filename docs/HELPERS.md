# wi3 Helper Commands & Reference

All scripts in `bin/` are symlinked into `~/.local/bin` by their respective modules.

---

## Session & Multi-Monitor Helpers

### `start-i3`
Launches i3 inside a nested `Xephyr` X server on WSLg, sets up `clip-bridge`, `fcitx5`, `GALLIUM_DRIVER=d3d12`, and `XDG_CURRENT_DESKTOP=X-Generic` (so `xdg-open` stays inside Linux/i3).

```bash
start-i3                      # 1920x1080 (or $I3_RES)
start-i3 2560x1440            # custom window size
start-i3 --on 1               # maximized on monitor 1 (0-indexed, left-to-right)
start-i3 --split              # one independent i3 instance per monitor
start-i3 --multi              # one Xinerama desktop spanning all monitors
start-i3 --multi -f           # same, fullscreen (no WSLg title bar)
```

- **Environment variables**: `I3_RES` (default `1920x1080`), `WSLG_DECOR_W` (default `12`), `WSLG_DECOR_H` (default `33`).

### `xephyr-fullscreen [toggle|on|off]`
Toggles fullscreen for the current i3 session's Xephyr window(s) on the host WSLg display (`$I3_HOST_DISPLAY`). Bound to `Alt+F11`.

### `i3-switch-instance [next|prev|<display>]`
Focuses another Xephyr i3 instance (used with `start-i3 --split` or `--on`) ordered left-to-right. Bound to `Alt+o`, `Alt+Ctrl+Right`, `Alt+Ctrl+Left`.

### `x-place-window "<title>" X Y [--fullscreen|--maximize] [--display :0]`
Internal helper used by `start-i3` to position and maximize/fullscreen Xephyr windows on the WSLg host display.

---

## Desktop Utilities

### `wallpaper`
Manages desktop wallpapers via `feh` and `rofi`.

```bash
wallpaper pick                                 # rofi grid picker with previews (Alt+Shift+w)
wallpaper set <file>                           # set and remember image
wallpaper random                               # pick random image from ~/Pictures/wallpapers
wallpaper restore                              # re-apply last wallpaper (called by i3 on start)
wallpaper windows                              # import current Windows wallpaper
wallpaper mode <fill|center|max|scale|tile>    # set feh scaling mode
```

- **Environment variables**: `WALLPAPER_DIR` (default `~/Pictures/wallpapers`).

### `screenshot`
Captures screenshots with `maim` + `slop` or annotates with `flameshot`. Every capture is saved to `~/Pictures/screenshots` and copied to the clipboard (synced to Windows via `clip-bridge`).

```bash
screenshot area | full | window [delay_sec]    # capture immediately or after delay
screenshot annotate                            # launch flameshot editor
screenshot menu                                # rofi screenshot menu (Alt+Shift+s)
```

- **Environment variables**: `SCREENSHOT_DIR` (default `~/Pictures/screenshots`).

### `clip-bridge <display_a> <display_b>`
Event-driven (`XFixes`) two-way clipboard bridge for text and PNG images. Launched automatically by `start-i3` between `:N` (i3) and `:0` (WSLg/Windows).

### `google-chrome`
Wrapper around `/usr/bin/google-chrome-stable` that enables GPU-accelerated WebGL inside Xephyr using `--use-angle=gl-egl` while disabling broken Xephyr GPU compositing.

- **Environment variables**: `CHROME_ANGLE` (default `gl-egl`; set `default` to disable), `CHROME_GPU_COMPOSITING=1` (to re-enable GPU compositing).

---

## Rofi & Polybar Helpers

| Command | Purpose |
| --- | --- |
| `rofi-sudo` | Run a command as `root` via `sudo -A` using `rofi-askpass` (`Alt+Ctrl+d`) |
| `rofi-askpass` | Rofi password prompt used by `rofi-sudo` |
| `rofi-powermenu` | Session menu: Lock (`i3lock`), Reload i3, Restart i3, Exit i3 (`Alt+Shift+e`) |
| `rofi-notifications` | Notification center & Do-Not-Disturb toggle (`Alt+Ctrl+n`) |
| `polybar-launch` | Restarts polybar scoped to the current `$DISPLAY` (supports `--multi` Xinerama) |
| `polybar-ipcountry` | Public IP country badge (left-click: toggle IP/country name; right-click: refresh) |
| `polybar-kblayout` | Shows `EN`/`FA` from `fcitx5`; click to toggle |
| `polybar-notifications` | Shows notification bell / DND icon and waiting count |
| `dunst-launch` | Starts or reloads `dunst` scoped to the current `$DISPLAY` |
| `fcitx5-launch` | Starts `fcitx5` once per `$DISPLAY` |

---

## VPN Helpers

### `fvpn` (Company VPN — `openfortivpn`)
Polybar/rofi front-end for `openfortivpn`. Runs in a floating terminal and moves to the i3 scratchpad once connected.

```bash
fvpn toggle | up | down | show | menu | bar
```

- **Config**: `~/.config/openfortivpn/config` (falls back to `/etc/openfortivpn/config`).
- **Environment variables**: `FORTI_LABEL` (default `Work`), `FORTI_CONFIG`, `FORTI_TRUSTED_CERT`.

### `vpn` (VLESS TUN — `~/vless-tun.sh`)
Polybar/rofi front-end for `~/vless-tun.sh`.

```bash
vpn toggle | up [--kill-switch] | down | status | log | menu | bar
```

- **Environment variables**: `VLESS_SCRIPT` (default `~/vless-tun.sh`).

---

## Module Environment Overrides

You can customize certain modules at install time:

```bash
OPENFORTI_VERSION=1.24.1 ./install.sh 09-openfortivpn
DRIVE=E MOUNT_POINT=/mnt/transcend ./install.sh 11-external-drive
UV_VERSION=0.13.9 ./install.sh 12-dev-tools
```

---

## Complete i3 Keybindings

| Category | Shortcut | Action |
| --- | --- | --- |
| **Apps** | `Alt+Enter` | Terminal (`alacritty`) |
| | `Alt+d` | App launcher (`rofi -show drun`) |
| | `Alt+Shift+d` | Run command (`rofi -show run`) |
| | `Alt+Ctrl+d` | Run as root (`rofi-sudo`) |
| | `Alt+Tab` / ``Alt+` `` | Window switcher |
| | `Alt+Shift+q` | Kill focused window |
| **Navigation** | `Alt+h/j/k/l` or `Arrows` | Focus left/down/up/right |
| | `Alt+Shift+h/j/k/l` or `Arrows` | Move window left/down/up/right |
| | `Alt+1..0` / `Alt+Shift+1..0` | Switch workspace / Move window to workspace `1..10` |
| **Layout** | `Alt+b` / `Alt+v` | Split horizontal / vertical |
| | `Alt+s` / `Alt+w` / `Alt+e` | Stacking / Tabbed / Toggle split |
| | `Alt+f` | Fullscreen window |
| | `Alt+Shift+Space` / `Alt+Space` | Toggle floating / Toggle focus mode |
| | `Alt+a` | Focus parent container |
| | `Alt+r` | Enter resize mode (`h/j/k/l` or arrows, `Esc`/`Enter` to exit) |
| **WSLg / Multi-instance** | `Alt+F11` | Toggle Xephyr fullscreen |
| | `Alt+o` / `Alt+Ctrl+Right` | Next i3 instance (`--split`) |
| | `Alt+Ctrl+Left` | Previous i3 instance (`--split`) |
| **Notifications** | `Alt+n` / `Alt+Shift+n` | Close notification / Close all |
| | `Alt+Ctrl+n` | Notification center (`rofi-notifications`) |
| | `Alt+.` | Notification context menu (`dunstctl context`) |
| **Screenshots** | `Print` / `Shift+Print` / `Alt+Print` | Area / Full screen / Active window |
| | `Alt+Shift+s` / `Alt+Ctrl+s` | Screenshot menu / Annotate (`flameshot`) |
| **Wallpaper & VPN** | `Alt+Shift+w` | Wallpaper picker |
| | `Alt+Shift+v` / `Alt+Ctrl+v` | VLESS VPN toggle / menu |
| | `Alt+Shift+o` / `Alt+Ctrl+o` | Company VPN (`fvpn`) toggle / menu |
| **Session** | `Alt+Shift+c` / `Alt+Shift+r` | Reload config / Restart i3 |
| | `Alt+Shift+e` | Power / session menu |
