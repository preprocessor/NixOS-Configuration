#!/usr/bin/env bash
set -euo pipefail

PACKAGES_OUT=$(nix run .#list-remote-packages)
if [ -z "$PACKAGES_OUT" ]; then
  exit 0
fi

mapfile -t PACKAGES <<<"$PACKAGES_OUT"

for pkg in "${PACKAGES[@]}"; do
  OUTPUTS_JSON=$(nix eval --json ".#packages.x86_64-linux.$pkg.outputs")
  OUTPUTS_OUT=$(jq -r '.[]' <<<"$OUTPUTS_JSON")
  mapfile -t OUTPUTS <<<"$OUTPUTS_OUT"

  for output in "${OUTPUTS[@]}"; do
    path=$(nix eval --raw ".#packages.x86_64-linux.$pkg.$output.outPath")
    printf '%s\n' "$path"
  done
done
