#!/usr/bin/env bash
# Developer tools:
#   glab      GitLab CLI (Ubuntu package)
#   uv / uvx  Python package & tool manager (official release, checksum-verified)
#   graphify  code -> knowledge graph skill for AI assistants (PyPI: graphifyy)
# Versions: UV_VERSION=0.13.9 ./install.sh 12-dev-tools
# Nothing here edits shell rc files (~/.local/bin is already on PATH).
set -euo pipefail
source "$ROOT/lib/common.sh"

UV_VERSION="${UV_VERSION:-0.13.9}"
BIN="$HOME/.local/bin"; mkdir -p "$BIN"

# --- glab ---------------------------------------------------------------------
apt_install glab ca-certificates curl

# --- uv -------------------------------------------------------------------------
if [[ "$("$BIN/uv" --version 2>/dev/null | awk '{print $2}')" == "$UV_VERSION" ]]; then
  info "uv $UV_VERSION already installed"
else
  case "$(uname -m)" in
    x86_64)  A=uv-x86_64-unknown-linux-gnu ;;
    aarch64) A=uv-aarch64-unknown-linux-gnu ;;
    *) die "No uv build for $(uname -m)" ;;
  esac
  U="https://github.com/astral-sh/uv/releases/download/$UV_VERSION"
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  info "Downloading uv $UV_VERSION"
  # slow links: resume + retry, give up only after 60 s below 1 KB/s
  dl() { curl -fsSL -C - --retry 5 --retry-delay 3 --speed-limit 1024 --speed-time 60 -o "$1" "$2"; }
  dl "$tmp/$A.tar.gz" "$U/$A.tar.gz"
  dl "$tmp/$A.tar.gz.sha256" "$U/$A.tar.gz.sha256"
  (cd "$tmp" && sha256sum -c --quiet "$A.tar.gz.sha256") || die "uv download damaged (checksum mismatch)"
  mkdir "$tmp/x"; tar -xzf "$tmp/$A.tar.gz" -C "$tmp/x"
  install -m 755 "$tmp/x/$A/uv" "$tmp/x/$A/uvx" "$BIN/"
  ok "uv $("$BIN/uv" --version | awk '{print $2}') installed"
fi

# --- graphify (PyPI package name is "graphifyy") ---------------------------------
if "$BIN/uv" tool list 2>/dev/null | grep -q '^graphifyy '; then
  info "graphify already installed ($("$BIN/uv" tool list | awk '/^graphifyy /{print $2}')); upgrade: uv tool upgrade graphifyy"
else
  "$BIN/uv" tool install graphifyy
fi
# Register the skill with the AI assistant(s) it detects (e.g. Claude Code)
if command -v graphify >/dev/null; then
  graphify install || warn "graphify install failed; run it manually later"
fi

ok "glab $(glab --version 2>/dev/null | awk '{print $3; exit}'), uv, graphify ready"
