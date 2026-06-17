#!/usr/bin/env bash
set -euo pipefail

REPO="walednajjar2-salam/launch-quality-mobile"
REMOTE_NAME="launch-quality-mobile"
BRANCH="${1:-main}"

echo "==> GitHub auth status"
if ! gh auth status >/dev/null 2>&1; then
  echo "Run: gh auth login"
  exit 1
fi

if ! gh repo view "$REPO" >/dev/null 2>&1; then
  echo "==> Creating $REPO"
  gh repo create "$REPO" --public \
    --description "Launch Quality LLC staff Android app — production API"
fi

if ! git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  git remote add "$REMOTE_NAME" "https://github.com/${REPO}.git"
fi

echo "==> Pushing branch $BRANCH to $REPO"
git push -u "$REMOTE_NAME" "$BRANCH"

echo "Done: https://github.com/${REPO}"
