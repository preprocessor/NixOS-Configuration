#!/usr/bin/env bash

new=$(
  ssh-keyscan -t ed25519 cache.wyspr.xyz 2>/dev/null |
    grep -v '^#' | awk '{print $2" "$3}' | base64 -w0
)

gh variable set CACHE_HOST_KEY --body "$new"
