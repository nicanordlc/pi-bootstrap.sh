#!/bin/bash
set -Eeuo pipefail

docker stop -t 0 coolify coolify-db coolify-proxy coolify-redis coolify-realtime; docker rm coolify coolify-db coolify-proxy coolify-redis coolify-realtime

rm -fr /data/coolify
