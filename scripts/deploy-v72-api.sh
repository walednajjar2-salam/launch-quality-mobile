#!/usr/bin/env bash
# Deploy Launch Quality ERP backend to legacy v72 Railway project (web-production-08d73).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLI="npx --yes @railway/cli@latest"
LEGACY_DOMAIN="${LEGACY_DOMAIN:-web-production-08d73.up.railway.app}"
API="https://${LEGACY_DOMAIN}/api"
SVC="${V72_SERVICE:-web}"

if [[ -z "${OLD_RAILWAY_TOKEN:-}" ]]; then
  echo "OLD_RAILWAY_TOKEN is required (Project token for the v72 Railway project)."
  echo "Create it: Railway → v72 project → Settings → Tokens → production"
  exit 1
fi

export RAILWAY_TOKEN="$OLD_RAILWAY_TOKEN"

echo "=== Deploy ERP to v72 (${LEGACY_DOMAIN}) service=${SVC} ==="
cd "$ROOT/backend/jawdah-cloud-v47"

$CLI variable set \
  LQ_EMERGENCY_PASSWORD_RESET=1 \
  LQ_PRODUCTION_URL="https://${LEGACY_DOMAIN}" \
  -s "$SVC" -e production --json >/dev/null || true

$CLI up --detach -y -s "$SVC" -e production

echo "Waiting for v72 redeploy..."
sleep 45

echo "Syncing authorized users on v72..."
LQ_API="$API" LQ_ADMIN_USER=admin LQ_ADMIN_PASSWORD=1234567891 \
  python3 "$ROOT/scripts/sync-authorized-users.py"

echo "Mirroring real estate data from Jawda-Al-Intilaqa..."
LQ_API="$API" LQ_BACKUP_API="https://jawda-al-intilaqa-production.up.railway.app/api" \
  LQ_ADMIN_USER=admin LQ_ADMIN_PASSWORD=1234567891 \
  python3 "$ROOT/scripts/restore-real-estate-production.py"

LQ_API="$API" python3 "$ROOT/scripts/sync-authorized-users.py"

$CLI variable set LQ_EMERGENCY_PASSWORD_RESET=0 -s "$SVC" -e production --json >/dev/null || true

echo ""
echo "=== Done ==="
echo "API: ${API}"
echo "ERP: https://${LEGACY_DOMAIN}/app.html"
