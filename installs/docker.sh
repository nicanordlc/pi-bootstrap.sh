#!/bin/bash
set -Eeuo pipefail

if which docker &>/dev/null; then
  exit 0
fi

#docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo groupadd docker || true
sudo usermod -aG docker "$USER" || true
