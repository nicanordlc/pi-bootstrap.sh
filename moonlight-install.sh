#!/bin/bash
set -Eeuo pipefail

URL='https://dl.cloudsmith.io/public/moonlight-game-streaming/moonlight-qt/setup.deb.sh'

curl -1sLf "$URL" |
  distro=raspbian \
  codename=$(lsb_release -cs) \
  sudo -E bash

sudo apt install -y moonlight-qt
