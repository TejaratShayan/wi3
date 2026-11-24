#!/usr/bin/env bash
# Main entry point: runs every module in modules/ in order.
# Usage:
#   ./install.sh            # run all modules
#   ./install.sh 01-i3      # run only the named module(s)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT
source "$ROOT/lib/common.sh"

if [[ $EUID -eq 0 ]]; then
  die "Run as your normal user (not root). sudo is used where needed."
fi

sudo -v   # ask for the password once up front

if [[ $# -gt 0 ]]; then
  modules=()
  for m in "$@"; do modules+=("$ROOT/modules/${m%.sh}.sh"); done
else
  modules=("$ROOT"/modules/*.sh)
fi

for m in "${modules[@]}"; do
  [[ -f "$m" ]] || die "Module not found: $m"
  step "Running $(basename "$m")"
  bash "$m"
done

ok "All done."
