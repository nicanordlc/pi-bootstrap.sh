#!/bin/bash
set -Eeuo pipefail

sudo mkdir -p /captain/data
sudo touch /captain/data/config-override.json
echo "{\"skipVerifyingDomains\":\"true\"}" | sudo tee /captain/data/config-override.json
docker run \
  -e ACCEPTED_TERMS=true \
  -e MAIN_NODE_IP_ADDRESS=10.0.0.37 \
  -p 80:80 \
  -p 443:443 \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /captain:/captain \
  caprover/caprover
