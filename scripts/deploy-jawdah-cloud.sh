#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/backend/jawdah-cloud-v47"

if [[ -z "${RAILWAY_TOKEN:-}" ]]; then
  echo "Set RAILWAY_TOKEN from Railway → Project → Settings → Tokens"
  exit 1
fi

npx --yes @railway/cli@latest up --detach --service "${RAILWAY_SERVICE:-Jawda-Al-Intilaqa}" \
  -p "${RAILWAY_PROJECT_ID:-9239907c-96e9-4763-b2d3-2d57931f7bba}" \
  -e "${RAILWAY_ENVIRONMENT:-production}"
