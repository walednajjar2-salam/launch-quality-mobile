#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/backend/jawdah-cloud-v47"

if [[ -z "${RAILWAY_TOKEN:-}" ]]; then
  echo "Set RAILWAY_TOKEN from Railway → Project → Settings → Tokens"
  exit 1
fi

npx --yes @railway/cli@latest up --detach --service "${RAILWAY_SERVICE:-web-production-08d73}"
