#!/usr/bin/env bash
# Deploy NAJJAR Auto Ads (API + React UI + MongoDB on Railway).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLI="npx --yes @railway/cli@latest"

PROJECT="${RAILWAY_PROJECT_ID:-9239907c-96e9-4763-b2d3-2d57931f7bba}"
ENV="${RAILWAY_ENVIRONMENT:-production}"
SVC="${NAJJAR_SERVICE:-NAJJAR-Auto-Ads-API}"
JWT_SECRET="${NAJJAR_JWT_SECRET:-$(openssl rand -hex 24)}"

if [[ -z "${RAILWAY_TOKEN:-}" ]]; then
  echo "RAILWAY_TOKEN is required"
  exit 1
fi

export RAILWAY_TOKEN

echo "=== Deploy NAJJAR Auto Ads ==="
echo "Service: $SVC (API + Web combined)"

cd "$ROOT/integrations/najjar-auto-ads"

$CLI variable set \
  JWT_SECRET="$JWT_SECRET" \
  DEMO_ADMIN_EMAIL="admin@najjar.om" \
  DEMO_ADMIN_PASSWORD="Najjar2026!" \
  NODE_ENV="production" \
  DATABASE_ENGINE="mongo" \
  'MONGODB_URI=${{MongoDB.MONGO_URL}}' \
  --service "$SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

$CLI up --detach -y -s "$SVC" -p "$PROJECT" -e "$ENV"

HOST="$($CLI domain list --service "$SVC" --project "$PROJECT" --environment "$ENV" --json 2>/dev/null | python3 -c "
import json,sys
try:
  items=json.load(sys.stdin)
  if isinstance(items,dict): items=items.get('domains',items.get('items',[]))
  for d in items:
    dom=d.get('domain') or d.get('host') or ''
    if dom: print(dom.replace('https://','').replace('http://','').strip('/')); break
except: pass
" 2>/dev/null || true)"

if [[ -z "$HOST" ]]; then
  $CLI domain --service "$SVC" --project "$PROJECT" --environment "$ENV" --json >/dev/null 2>&1 || true
  sleep 3
  HOST="$($CLI domain list --service "$SVC" --project "$PROJECT" --environment "$ENV" --json 2>/dev/null | python3 -c "
import json,sys
try:
  items=json.load(sys.stdin)
  if isinstance(items,dict): items=items.get('domains',items.get('items',[]))
  for d in items:
    dom=d.get('domain') or d.get('host') or ''
    if dom: print(dom.replace('https://','').replace('http://','').strip('/')); break
except: pass
" 2>/dev/null || true)"
fi

[[ -z "$HOST" ]] && HOST="najjar-auto-ads-api-production.up.railway.app"
APP_URL="https://${HOST}"
API_URL="${APP_URL}/api"

$CLI variable set CORS_ORIGIN="${APP_URL},http://localhost:3000" \
  --service "$SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

echo ""
echo "=== Done ==="
echo "App:  ${APP_URL}"
echo "API:  ${API_URL}"
echo "Login: admin@najjar.om / Najjar2026!"
