#!/usr/bin/env bash
# Installs openfortivpn (Fortinet SSL-VPN client) pinned to one version.
#   - uses Ubuntu's package if apt offers exactly that version (then holds it)
#   - otherwise builds that release from upstream source into /usr/local
# Change the version: OPENFORTI_VERSION=1.24.1 ./install.sh 09-openfortivpn
set -euo pipefail
source "$ROOT/lib/common.sh"

VERSION="${OPENFORTI_VERSION:-1.24.0}"
REPO="https://github.com/adrienverge/openfortivpn"

installed_version() {
  command -v openfortivpn >/dev/null || return 0
  openfortivpn --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

cur="$(installed_version)"
if [[ $cur == "$VERSION" ]]; then
  ok "openfortivpn $VERSION is already installed ($(command -v openfortivpn))"
  mkdir -p "$HOME/.local/bin"; chmod +x "$ROOT/bin/fvpn"
  link_file "$ROOT/bin/fvpn" "$HOME/.local/bin/fvpn"
  exit 0
fi
[[ -n $cur ]] && warn "openfortivpn $cur is installed; switching to $VERSION"

# ppp provides pppd, which openfortivpn needs at runtime
apt_install ppp ca-certificates

# 1) Ubuntu package with exactly this version?
pkgver="$(apt-cache madison openfortivpn 2>/dev/null | awk -v v="$VERSION" '$3 ~ "^"v"-" {print $3; exit}')"
if [[ -n $pkgver ]]; then
  info "Installing Ubuntu package openfortivpn=$pkgver"
  sudo apt-mark unhold openfortivpn >/dev/null 2>&1 || true
  sudo apt-get install -y --allow-downgrades "openfortivpn=$pkgver"
  sudo apt-mark hold openfortivpn >/dev/null
  info "Held at $pkgver (apt won't upgrade it; undo: sudo apt-mark unhold openfortivpn)"
else
  # 2) Build the release from source
  info "apt has no $VERSION; building from source ($REPO, tag v$VERSION)"
  if dpkg -s openfortivpn &>/dev/null; then
    sudo apt-mark unhold openfortivpn >/dev/null 2>&1 || true
    sudo apt-get remove -y openfortivpn
  fi
  apt_install build-essential autoconf automake pkg-config libssl-dev curl
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  curl -fsSL --max-time 120 "$REPO/archive/refs/tags/v$VERSION.tar.gz" -o "$tmp/src.tar.gz" ||
    die "Download failed (does v$VERSION exist? see $REPO/releases)"
  tar -xzf "$tmp/src.tar.gz" -C "$tmp"
  cd "$tmp/openfortivpn-$VERSION"
  ./autogen.sh >/dev/null
  ./configure --prefix=/usr/local --sysconfdir=/etc >/dev/null
  make -j"$(nproc)" >/dev/null
  sudo make install >/dev/null
  hash -r
fi

cur="$(installed_version)"
[[ $cur == "$VERSION" ]] || die "Expected openfortivpn $VERSION, got '${cur:-nothing}'"
ok "openfortivpn $cur installed: $(command -v openfortivpn)"

mkdir -p "$HOME/.local/bin"
chmod +x "$ROOT/bin/fvpn"
link_file "$ROOT/bin/fvpn" "$HOME/.local/bin/fvpn"
info "Status bar: company VPN item in polybar (Alt+Shift+o toggle, Alt+Ctrl+o menu)"
echo "    Connect: sudo openfortivpn vpn.company.com:443 -u USER"
echo "    Or put host/port/username in /etc/openfortivpn/config and run: sudo openfortivpn"
