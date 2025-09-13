#!/usr/bin/env bash
set -Eeuo pipefail
#
#  set_swapsize.sh
#
#  Change CONF_SWAPSIZE in /etc/dphys-swapfile from 512 to 2048.
#  Creates a backup before modifying the file.
#
#  Usage:  sudo ./set_swapsize.sh
#
#  After changing the file, restart the swap service (or reboot) to apply.
#

# ---- Config ------------------------------------------------------------
SWAPFILE="/etc/dphys-swapfile"
NEW_SIZE="2048"

# ---- Safety ------------------------------------------------------------
# Ensure we are running as root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root."
  exit 1
fi

# Backup the original file
BACKUP="${SWAPFILE}.bak.$(date +%Y%m%d%H%M%S)"
cp -p "$SWAPFILE" "$BACKUP"
echo "Backup created: $BACKUP"

# ---- Modify ------------------------------------------------------------
# 1) If an active line exists, replace it
# 2) If only a commented line exists, uncomment it and set the new value
# 3) If no line exists, append a new one

# Try to replace an active line first
if grep -q '^CONF_SWAPSIZE=' "$SWAPFILE"; then
  sed -i -e "s/^CONF_SWAPSIZE=[0-9]\+$/CONF_SWAPSIZE=${NEW_SIZE}/" "$SWAPFILE"
  echo "Updated active CONF_SWAPSIZE to ${NEW_SIZE}."
# No active line – try a commented one
elif grep -q '^[# ]*CONF_SWAPSIZE=' "$SWAPFILE"; then
  sed -i -e "s/^[# ]*CONF_SWAPSIZE=[0-9]\+$/CONF_SWAPSIZE=${NEW_SIZE}/" "$SWAPFILE"
  echo "Uncommented and updated CONF_SWAPSIZE to ${NEW_SIZE}."
else
  # Append a new line at the end
  echo "CONF_SWAPSIZE=${NEW_SIZE}" >>"$SWAPFILE"
  echo "Appended new CONF_SWAPSIZE=${NEW_SIZE}."
fi

# ---- Done -------------------------------------------------------------
echo "Done. To apply the change, restart the service or reboot:"
echo "    sudo systemctl restart dphys-swapfile"
echo "or simply reboot the machine."
