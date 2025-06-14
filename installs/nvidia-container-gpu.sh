#!/bin/bash
set -Eeuo pipefail

# setup production repo
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# update packages list
sudo apt-get update

# install nvidia container toolkit
sudo apt-get install -y nvidia-container-toolkit

# configure docker
sudo nvidia-ctk runtime configure --runtime=docker

# restart docker daemon
sudo systemctl restart docker
