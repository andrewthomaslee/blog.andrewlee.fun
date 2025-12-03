#!/usr/bin/env bash

set -euo pipefail
source $REPO_ROOT/.env

# Build the stream script
nix build $REPO_ROOT?submodules=1#hugo-container-stream

# Extract the hash from the build result path (e.g. /nix/store/<hash>-hugo-container-stream)
IMAGE_PATH=$(readlink -f result)
HASH=$(basename $IMAGE_PATH | cut -d- -f1)

# Construct the destination tag
NEW_TAG="$REGISTRY/$REPO:$HASH"
echo "Pushing $NEW_TAG"

# Stream the image -> compress -> push with skopeo
./result | gzip --fast | skopeo copy docker-archive:/dev/stdin docker://$NEW_TAG
