#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o functrace
set -o nounset
set -o pipefail
set -o xtrace

sudo apt install -y \
    docker-buildx \
    shellcheck \

# Lint this script using shellcheck
shellcheck "$0"

# Clean up previous build
rm -rf magic-lantern
sudo docker rm ml-hg2git || true

# Create new build
sudo docker buildx build -t ml-hg2git:latest .
sudo docker create --name ml-hg2git ml-hg2git:latest
sudo docker cp ml-hg2git:/src/magic-lantern .
sudo chown -R "${USER}:${USER}" magic-lantern

# Commands that are convenient for debugging and/or development
sudo docker run ml-hg2git
# sudo docker run -it ml-hg2git bash
