#!/bin/bash
set -Eeuo pipefail

# Step 1: Identify the active network connection
active_connection=$(nmcli -t -f NAME con show --active | grep -v '^lo$')

# Check if an active connection was found
if [ -z "$active_connection" ]; then
  echo "No active network connection found."
  exit 1
fi

# Step 2: Set the DNS server to 1.1.1.1 for the active connection
nmcli con modify "$active_connection" ipv4.dns "1.1.1.1"
nmcli con modify "$active_connection" ipv4.ignore-auto-dns yes

# Step 3: Restart the connection to apply changes
nmcli con down "$active_connection"
nmcli con up "$active_connection"

# Step 4: Verify the DNS settings
echo "DNS settings for '$active_connection':"
nmcli con show "$active_connection" | grep dns

# Step 5: Check /etc/resolv.conf
echo "Contents of /etc/resolv.conf:"
cat /etc/resolv.conf
