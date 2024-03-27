#!/bin/bash
set -Eeuo pipefail

_run(){
  local REPO_URL file_path
  REPO_URL="https://raw.githubusercontent.com/cabaalexander/pi-bootstrap.sh/main"
  file_path=$(basename ${1:-})
  curl -fsSL ${REPO_URL}/${file_path} | bash 
}

_run ./init.sh

_run ./coolify.sh
 
