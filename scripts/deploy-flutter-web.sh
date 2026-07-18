#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
: "${RAILWAY_TOKEN:?Set RAILWAY_TOKEN to the Jawda-Al-Intilaqa project token}"
npx --yes @railway/cli up --detach --service "${RAILWAY_FLUTTER_SERVICE:-Launch-Quality-Mobile}" \
  -p "${RAILWAY_PROJECT_ID:-9239907c-96e9-4763-b2d3-2d57931f7bba}" \
  -e "${RAILWAY_ENVIRONMENT:-production}"
