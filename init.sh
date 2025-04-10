#!/bin/bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/nicanordlc/pi-bootstrap.sh/main"

_run() {
  local file_path req_url
  file_path="$1"
  req_url=${REPO_URL}/"${file_path}"
  curl -fsSL "$req_url" | bash
}

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y \
  libimage-exiftool-perl \
  exfat-fuse \
  dnsutils \
  vim \
  git \
  vifm \
  tmux

_run ./installs/docker.sh
