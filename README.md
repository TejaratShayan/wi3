```text
██╗    ██╗██╗██████╗
██║    ██║██║╚════██╗
██║ █╗ ██║██║ █████╔╝
██║███╗██║██║ ╚═══██╗
╚███╔███╔╝██║██████╔╝
 ╚══╝╚══╝ ╚═╝╚═════╝
  i3wm on WSL2 / WSLg
```

# wi3

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: WSL2](https://img.shields.io/badge/Platform-WSL2%20%2F%20WSLg-0078D6.svg)](https://learn.microsoft.com/en-us/windows/wsl/)

Reproducible, modular **i3** desktop environment for **WSL2 (WSLg) Ubuntu**.

Runs i3 inside a nested Xephyr X server with multi-monitor support, Catppuccin-styled Rofi/Polybar/Dunst/Alacritty configs, two-way Windows clipboard sync, Persian/English input (`fcitx5`), GPU acceleration via WSL D3D12, VPN controls, and developer tools.

---

## Quick Start

```bash
git clone https://github.com/TejaratShayan/wi3.git
cd wi3

# Run all setup modules in order (safe to re-run)
./install.sh

# Or run specific module(s) only
./install.sh 01-i3
./install.sh 02-rofi 03-polybar
```

> Run as your normal user (not `root`); `sudo` is prompted once up front.
> After the first install, run `wsl --shutdown` from Windows if you were newly added to the `video`/`render` groups, and open a new terminal for `zsh`.

### Launching i3

```bash
start-i3                 # single window (default 1920x1080, or $I3_RES)
start-i3 2560x1440       # single window with custom resolution
start-i3 --on 1          # one instance maximized on monitor 1 (0-indexed, left-to-right)
start-i3 --split         # one independent i3 instance per monitor
start-i3 --multi         # one screen per monitor, joined into one desktop (Xinerama)
```

Add `--fullscreen` (`-f`) to `--on`, `--split`, or `--multi` to start without a title bar. Press `Alt+F11` inside i3 to toggle Xephyr fullscreen at any time.

---

## Repository Layout

| Path | Purpose |
| --- | --- |
| `install.sh` | Main entry point; runs all or selected `modules/*.sh` |
| `lib/common.sh` | Shared helpers (`apt_install`, `link_file`, colored logging) |
| `modules/NN-*.sh` | Idempotent setup steps, executed in numeric order |
| `config/` | Dotfiles symlinked into `~/.config` (and `~/.zshrc`) |
| `bin/` | Helper scripts symlinked into `~/.local/bin` |
| `docs/HELPERS.md` | Full reference for helper commands, keybindings, env vars, and troubleshooting |

Machine-specific shell overrides go in `~/.zshrc.local` (not tracked).

---

## Modules

| Module | What it sets up |
| --- | --- |
| `01-i3` | `i3-wm`, `Xephyr`, `alacritty`, GPU groups (`video`, `render`), `start-i3` & multi-monitor helpers |
| `02-rofi` | `rofi` app/window/run launcher, Papirus icons, JetBrains Mono, root launcher (`rofi-sudo`) |
| `03-polybar` | `polybar` status bar, power menu, IP-country badge, VLESS VPN front-end (`vpn`) |
| `04-dunst` | `dunst` notification daemon, rofi notification center, polybar DND/count indicator |
| `05-zsh` | `zsh` login shell, autosuggestions & syntax highlighting, `starship`, `fzf`, `zoxide`, `eza`, `bat`, `alacritty` theme |
| `06-clipboard` | Event-driven two-way clipboard bridge (`clip-bridge`) for text & PNG images between i3 and Windows |
| `07-wallpaper` | `feh` + rofi wallpaper picker (`wallpaper`); imports current Windows wallpaper by default |
| `08-screenshot` | `maim` + `slop` quick capture, `flameshot` annotation editor, rofi screenshot menu (`screenshot`) |
| `09-openfortivpn` | `openfortivpn` pinned to `1.24.0` (apt hold or built from source) + polybar/rofi front-end (`fvpn`) |
| `10-keyboard` | Persian/English typing via `fcitx5` + Vazirmatn font + polybar `EN`/`FA` indicator |
| `11-external-drive` | Mounts Windows drive `E:` at `/mnt/transcend` via `/etc/fstab` (`nofail`) |
| `12-dev-tools` | `glab` (apt), `uv`/`uvx` (checksum-verified release), `graphify` (`uv tool install graphifyy`) |
| `13-gpu` | WSL D3D12 GPU bridge (`GALLIUM_DRIVER=d3d12`) + Chrome WebGL wrapper (`google-chrome`) |

---

## Essential Keybindings

The modifier key (`$mod`) is **Alt** (`Mod1`), because Windows intercepts the Super/Win key under WSL.

| Shortcut | Action |
| --- | --- |
| `Alt+Enter` | Open terminal (`alacritty`) |
| `Alt+d` / `Alt+Shift+d` / `Alt+Ctrl+d` | App launcher / Run command / Run as root |
| `Alt+Tab` or ``Alt+` `` | Window switcher |
| `Alt+Shift+q` | Close window |
| `Alt+Shift+e` | Session / power menu (Lock, Reload, Restart, Exit) |
| `Alt+Shift+r` / `Alt+Shift+c` | Restart i3 / Reload config |
| `Alt+F11` | Toggle Xephyr fullscreen |
| `Alt+o` / `Alt+Ctrl+Left,Right` | Switch between `--split` i3 instances |
| `Print` / `Alt+Shift+s` / `Alt+Ctrl+s` | Area screenshot / Screenshot menu / Annotate |
| `Alt+Shift+w` | Wallpaper picker |
| `Alt+Ctrl+n` | Notification center |
| `Alt+Shift+v` / `Alt+Ctrl+v` | Toggle VLESS VPN / VPN menu |
| `Alt+Shift+o` / `Alt+Ctrl+o` | Toggle Company VPN (`openfortivpn`) / menu |
| `Alt+Shift` or `Both Shifts` | Switch keyboard layout (`EN` ↔ `FA`) |

See [docs/HELPERS.md](docs/HELPERS.md) for the complete keybinding table, CLI helper usage, and environment variable overrides.

---

## Contributing & License

- Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md).
- For security issues, please see [SECURITY.md](SECURITY.md).
- Licensed under the [MIT License](LICENSE).
