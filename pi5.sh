#!/bin/bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/cabaalexander/pi-bootstrap.sh/main"

_run(){
  local file_path
  file_path=$(basename ${1:-})
  curl -fsSL ${REPO_URL}/${file_path} | bash 
}

_copy_sudo(){
  local file_path dst_path
  file_path=${1:-}
  dst_path=${2:-}
  curl -fsSL ${REPO_URL}/${file_path:1} | sudo tee $dst_path > /dev/null
}

#start

_run ./init.sh

_copy_sudo \
  ./config/etc-network-interfaces-d-main.conf \
  /etc/network/interfaces.d/main.conf

_run ./coolify.sh
 
# ### This needs to be run last since it will restart network manager
# set a fixed DNS for the server
sudo nmcli connection modify preconfigured ipv4.ignore-auto-dns yes
sudo nmcli connection modify preconfigured ipv4.dns "1.1.1.1"
sudo systemctl restart NetworkManager
# check DNS: nmcli dev show | grep DNS

