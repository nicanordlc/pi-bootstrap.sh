#!/bin/bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/cabaalexander/pi-bootstrap.sh/main"

_run(){
  local file_path
  file_path=$(basename ${1:-})
  curl -fsSL ${REPO_URL}/${file_path} | bash 
}

#apps
sudo apt install -y \
  libimage-exiftool-perl \
  exfat-fuse \
  dnsutils \
  vim \
  git \
  tmux

#start

_run ./docker.sh

