#!/usr/bin/env bash

set -euo pipefail

hugo server --disableFastRender --noHTTPCache -s $REPO_ROOT/hugo