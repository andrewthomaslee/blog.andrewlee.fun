#!/usr/bin/env bash

set -euo pipefail

nix build $REPO_ROOT?submodules=1#hugo-container
IMAGE_TAG=$(docker load < result | grep -o 'hugo-container:[^ ]*')
echo "Running @ http://localhost:8080"
docker run --rm -p 8080:8080 $IMAGE_TAG