#!/bin/bash
set -Eeuo pipefail

#apps
sudo apt install -y \
  vim \
  git \
  tmux

#docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo groupadd docker || true
sudo usermod -aG docker $USER || true

