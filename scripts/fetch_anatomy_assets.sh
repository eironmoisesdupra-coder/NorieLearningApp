#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/anatomy

fetch_asset() {
  local label="$1"
  local source="$2"
  local target="$3"
  local minimum_size="$4"

  echo "Fetching $label..."
  curl -L --fail --retry 3 --retry-delay 2 "$source" -o "$target"

  local size
  size=$(wc -c < "$target")
  if [ "$size" -lt "$minimum_size" ]; then
    echo "Downloaded $label is unexpectedly small: $size bytes" >&2
    exit 1
  fi

  echo "$label ready: $size bytes"
}

fetch_asset   "Open3Dmodel skeleton"   "https://github.com/yamz8/human-body-simulator/raw/refs/heads/main/public/models/overview-skeleton.glb"   "assets/anatomy/overview-skeleton.glb"   1000000

fetch_asset   "BodyParts3D organ atlas"   "https://github.com/yamz8/human-body-simulator/raw/refs/heads/main/public/models/anatomy-organs.glb"   "assets/anatomy/anatomy-organs.glb"   250000
