#!/usr/bin/env bash
set -euo pipefail

CACHE_URL="${CACHE_URL:-https://cache.wyspr.xyz}"

PACKAGES_OUT=$(nix run .#list-remote-packages)
if [ -z "$PACKAGES_OUT" ]; then
  echo "[]"
  exit 0
fi

mapfile -t PACKAGES <<<"$PACKAGES_OUT"

MISSING=()
for pkg in "${PACKAGES[@]}"; do
  if ! OUTPUTS_JSON=$(nix eval --json ".#packages.x86_64-linux.$pkg.outputs" 2>/dev/null); then
    echo "::error::Evaluation failed for package: $pkg" >&2
    exit 1
  fi

  OUTPUTS_OUT=$(jq -r '.[]' <<<"$OUTPUTS_JSON")
  mapfile -t OUTPUTS <<<"$OUTPUTS_OUT"

  for output in "${OUTPUTS[@]}"; do
    if ! STORE_PATH=$(nix eval --raw ".#packages.x86_64-linux.$pkg.$output.outPath" 2>/dev/null); then
      echo "::error::Evaluation failed for output '$output' of package: $pkg" >&2
      exit 1
    fi
    if ! nix path-info --store "$CACHE_URL" -r "$STORE_PATH" >/dev/null 2>&1; then
      MISSING+=("$pkg")
      break
    fi
  done
done

if [ "${#MISSING[@]}" -eq 0 ]; then
  echo "All packages are cached." >&2
  echo "[]"
else
  printf '%s\n' "${MISSING[@]}" | jq -R . | jq -s -c .
fi
