# Shared helpers for setup modules.
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
info() { printf '\033[0;36m  -> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m  ✔ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m  ! %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31m  ✘ %s\033[0m\n' "$*" >&2; exit 1; }

# apt_install pkg...  -- installs only the missing packages
apt_install() {
  local missing=()
  for p in "$@"; do
    dpkg -s "$p" &>/dev/null || missing+=("$p")
  done
  if ((${#missing[@]})); then
    info "Installing: ${missing[*]}"
    sudo apt-get install -y --no-install-recommends "${missing[@]}"
  else
    info "Already installed: $*"
  fi
}

# link_file <source> <target>  -- symlink, backing up an existing real file
link_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    info "Already linked: $dst"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backing up $dst -> $bak"
    mv "$dst" "$bak"
  fi
  ln -s "$src" "$dst"
  ok "Linked $dst -> $src"
}
