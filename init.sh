#!/bin/bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/cabaalexander/pi-bootstrap.sh/main"

_run(){
  local file_path
  file_path=$(basename ${1:-})
  curl -fsSL ${REPO_URL}/${file_path} | bash 
}

_copy(){
  local file_path dst_path
  file_path=$(basename ${1:-})
  dst_path=${2:-}
  curl -fsSL ${REPO_URL}/${file_path} > $dst_path
}

#apps
sudo apt install -y \
  libimage-exiftool-perl \
  exfat-fuse \
  dnsutils \
  vim \
  git \
  tmux

# set a fixed DNS for the server
sudo nmcli connection modify preconfigured ipv4.ignore-auto-dns yes
sudo nmcli connection modify preconfigured ipv4.dns "1.1.1.1"
sudo systemctl restart NetworkManager
# check DNS: nmcli dev show | grep DNS

_run ./docker.sh

_copy \
  ./config/etc-network-interfaces-d-main.conf \
  /etc/network/interfaces.d/main.conf

