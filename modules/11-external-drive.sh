#!/usr/bin/env bash
# Mount a Windows drive (e.g. the external "Transcend" disk, E:) into WSL,
# now and on every WSL start (/etc/fstab, nofail = fine when unplugged).
#   DRIVE=E MOUNT_POINT=/mnt/transcend ./install.sh 11-external-drive
set -euo pipefail
source "$ROOT/lib/common.sh"

DRIVE="${DRIVE:-E}"; DRIVE="${DRIVE%:}"; DRIVE="${DRIVE^^}"
MP="${MOUNT_POINT:-/mnt/transcend}"
OPTS="metadata,uid=$(id -u),gid=$(id -g),umask=022,nofail"

# Is the drive visible in Windows?
if ! powershell.exe -NoProfile -Command "if (Get-Volume -DriveLetter $DRIVE -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >/dev/null 2>&1; then
  warn "Windows has no drive $DRIVE: right now (is it plugged in?). Adding the fstab entry anyway."
  PRESENT=0
else
  PRESENT=1
fi

sudo mkdir -p "$MP"

# Something already mounted there?
if findmnt -rn -T "$MP" -o TARGET | grep -qx "$MP"; then
  src="$(findmnt -rn -M "$MP" -o SOURCE)"; fst="$(findmnt -rn -M "$MP" -o FSTYPE)"
  rootsrc="$(findmnt -rn -M / -o SOURCE)"
  if [[ $fst == 9p && $src == "${DRIVE}:\\"* ]]; then
    info "$DRIVE: is already mounted at $MP"
  elif [[ $src == "$rootsrc" ]]; then
    warn "$MP is a second mount of the WSL system disk ($src); unmounting it (/ is unaffected)"
    sudo umount "$MP"
  else
    die "$MP already has $src ($fst) mounted; unmount it or choose MOUNT_POINT=..."
  fi
fi

# Persist in /etc/fstab (replace an older line for this mount point)
line="$DRIVE: $MP drvfs $OPTS 0 0"
if grep -qE "^[^#]*[[:space:]]$MP[[:space:]]" /etc/fstab; then
  if ! grep -qxF "$line" /etc/fstab; then
    sudo sed -i.bak "\#^[^\#]*[[:space:]]$MP[[:space:]]#d" /etc/fstab
    echo "$line" | sudo tee -a /etc/fstab >/dev/null
    info "Updated /etc/fstab (backup: /etc/fstab.bak)"
  fi
else
  echo "$line" | sudo tee -a /etc/fstab >/dev/null
  info "Added to /etc/fstab: $line"
fi

# Mount now
if ((PRESENT)) && ! findmnt -rn -M "$MP" >/dev/null; then
  sudo mount "$MP"
fi
if findmnt -rn -M "$MP" >/dev/null; then
  ok "$DRIVE: mounted at $MP ($(df -h "$MP" | awk 'NR==2 {print $3" used of "$2}'))"
else
  warn "Not mounted now; it will mount on the next WSL start when the drive is connected (or: sudo mount $MP)"
fi
