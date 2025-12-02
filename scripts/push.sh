#!/usr/bin/env bash

set -euo pipefail

nix build $REPO_ROOT?submodules=1#hugo-container
IMAGE_TAG=$(docker load < result | grep -o 'hugo-container:[^ ]*')
HASH=${IMAGE_TAG#*:}
NEW_TAG="$REGISTRY/$REPO:$HASH"
echo "Pushing $NEW_TAG"
docker tag $IMAGE_TAG $NEW_TAG
docker push $NEW_TAG