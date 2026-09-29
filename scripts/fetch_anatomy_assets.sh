#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/anatomy

TARGET="assets/anatomy/overview-skeleton.glb"
SOURCE="https://github.com/yamz8/human-body-simulator/raw/refs/heads/main/public/models/overview-skeleton.glb"

echo "Fetching Open3Dmodel skeleton..."
curl -L --fail --retry 3 --retry-delay 2 "$SOURCE" -o "$TARGET"

SIZE=$(wc -c < "$TARGET")
if [ "$SIZE" -lt 1000000 ]; then
  echo "Downloaded anatomy asset is unexpectedly small: $SIZE bytes" >&2
  exit 1
fi

echo "Anatomy skeleton ready: $SIZE bytes"
