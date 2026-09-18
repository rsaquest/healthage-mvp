#!/usr/bin/env bash
set -euo pipefail
# Usage: ./encode_keystore.sh [path/to/key.jks] [--upload KEYSTORE_PASSWORD KEY_ALIAS KEY_PASSWORD]

KEY_PATH="${1:-android/key.jks}"
if [ ! -f "$KEY_PATH" ]; then
  echo "Keystore not found: $KEY_PATH" >&2
  exit 1
fi

BASE64=$(base64 "$KEY_PATH" | tr -d '\n')
echo "$BASE64"

if [ "${2:-}" = "--upload" ]; then
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found. Install GitHub CLI to upload secrets." >&2
    exit 1
  fi
  KEYSTORE_PASSWORD="$3"
  KEY_ALIAS="$4"
  KEY_PASSWORD="$5"
  gh secret set KEYSTORE_BASE64 --body "$BASE64"
  gh secret set KEYSTORE_PASSWORD --body "$KEYSTORE_PASSWORD"
  gh secret set KEY_ALIAS --body "$KEY_ALIAS"
  gh secret set KEY_PASSWORD --body "$KEY_PASSWORD"
  echo "Secrets uploaded to GitHub repository."
fi
