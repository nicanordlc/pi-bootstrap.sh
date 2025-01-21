#!/bin/bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/nicanordlc/pi-bootstrap.sh/main"

_run() {
  local file_path
  file_path=$(basename "${1:-}")
  curl -fsSL ${REPO_URL}/"${file_path}" | bash
}

#start

_run ./init.sh

_run ./installs/coolify.sh

# ### This needs to be run last since it will restart network manager
# set a fixed DNS for the server
sudo nmcli connection modify preconfigured ipv4.ignore-auto-dns yes
sudo nmcli connection modify preconfigured ipv4.dns "1.1.1.1"
sudo systemctl restart NetworkManager
# check DNS: nmcli dev show | grep DNS
