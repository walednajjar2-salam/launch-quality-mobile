#!/usr/bin/env bash
# Deploy NAJJAR Auto Ads API + Web to Railway (SQLite — no MongoDB required).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLI="npx --yes @railway/cli@latest"

PROJECT="${RAILWAY_PROJECT_ID:-9239907c-96e9-4763-b2d3-2d57931f7bba}"
ENV="${RAILWAY_ENVIRONMENT:-production}"
API_SVC="${NAJJAR_API_SERVICE:-NAJJAR-Auto-Ads-API}"
WEB_SVC="${NAJJAR_WEB_SERVICE:-NAJJAR-Auto-Ads-Web}"
JWT_SECRET="${NAJJAR_JWT_SECRET:-$(openssl rand -hex 24)}"

if [[ -z "${RAILWAY_TOKEN:-}" ]]; then
  echo "RAILWAY_TOKEN is required"
  exit 1
fi

export RAILWAY_TOKEN

echo "=== Deploy NAJJAR Auto Ads ==="

echo "Deploying API service: $API_SVC"
cd "$ROOT/integrations/najjar-auto-ads/backend"
$CLI variable set \
  JWT_SECRET="$JWT_SECRET" \
  DEMO_ADMIN_EMAIL="admin@najjar.om" \
  DEMO_ADMIN_PASSWORD="Najjar2026!" \
  NODE_ENV="production" \
  NAJJAR_DATA_DIR="/app/data" \
  --service "$API_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

$CLI up --detach -y -s "$API_SVC" -p "$PROJECT" -e "$ENV"

API_HOST="$($CLI domain -s "$API_SVC" -p "$PROJECT" -e "$ENV" --json 2>/dev/null | python3 -c "
import json,sys
try:
  d=json.load(sys.stdin)
  print((d.get('domain') or d.get('host') or '').replace('https://','').replace('http://','').strip('/'))
except: pass
" 2>/dev/null || true)"

if [[ -z "$API_HOST" ]]; then
  $CLI domain -s "$API_SVC" -p "$PROJECT" -e "$ENV" --json >/dev/null 2>&1 || true
  sleep 3
  API_HOST="$($CLI domain list -s "$API_SVC" -p "$PROJECT" -e "$ENV" --json 2>/dev/null | python3 -c "
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

[[ -z "$API_HOST" ]] && API_HOST="najjar-auto-ads-api-production.up.railway.app"
API_URL="https://${API_HOST}/api"
echo "API: $API_URL"

echo "Deploying Web service: $WEB_SVC"
cd "$ROOT/integrations/najjar-auto-ads/frontend"
$CLI variable set VITE_API_BASE_URL="$API_URL" \
  --service "$WEB_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

$CLI variable set CORS_ORIGIN="https://${WEB_SVC,,}-production.up.railway.app,http://localhost:3000" \
  --service "$API_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

$CLI up --detach -y -s "$WEB_SVC" -p "$PROJECT" -e "$ENV"

WEB_HOST="$($CLI domain list -s "$WEB_SVC" -p "$PROJECT" -e "$ENV" --json 2>/dev/null | python3 -c "
import json,sys
try:
  items=json.load(sys.stdin)
  if isinstance(items,dict): items=items.get('domains',items.get('items',[]))
  for d in items:
    dom=d.get('domain') or d.get('host') or ''
    if dom: print(dom.replace('https://','').replace('http://','').strip('/')); break
except: pass
" 2>/dev/null || true)"
[[ -z "$WEB_HOST" ]] && WEB_HOST="najjar-auto-ads-web-production.up.railway.app"

# Update CORS with actual web domain
$CLI variable set CORS_ORIGIN="https://${WEB_HOST},http://localhost:3000" \
  --service "$API_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null || true

echo ""
echo "=== Done ==="
echo "Web:  https://${WEB_HOST}"
echo "API:  ${API_URL}"
echo "Login: admin@najjar.om / Najjar2026!"
