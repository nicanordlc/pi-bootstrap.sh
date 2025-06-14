#!/bin/bash
set -Eeuo pipefail

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts
nvm use --lts
