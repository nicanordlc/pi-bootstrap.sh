#!/bin/bash
set -Eeuo pipefail

docker service rm $(docker service ls -q)
## remove CapRover settings directory
sudo rm -rf /captain
## leave swarm if you don't want it
docker swarm leave --force
## full cleanup of docker
docker system prune --all --force
