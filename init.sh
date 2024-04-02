#!/bin/bash
set -Eeuo pipefail

_run(){
  local REPO_URL file_path
  REPO_URL="https://raw.githubusercontent.com/cabaalexander/pi-bootstrap.sh/main"
  file_path=$(basename ${1:-})
  curl -fsSL ${REPO_URL}/${file_path} | bash 
}

#apps
sudo apt install -y \
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

