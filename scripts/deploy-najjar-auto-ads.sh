#!/usr/bin/env bash
# Provision and deploy NAJJAR Auto Ads on Railway (MongoDB + API + Web).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLI="npx --yes @railway/cli@latest"

PROJECT="${RAILWAY_PROJECT_ID:-9239907c-96e9-4763-b2d3-2d57931f7bba}"
ENV="${RAILWAY_ENVIRONMENT:-production}"
MONGO_SVC="${NAJJAR_MONGO_SERVICE:-NAJJAR-MongoDB}"
API_SVC="${NAJJAR_API_SERVICE:-NAJJAR-Auto-Ads-API}"
WEB_SVC="${NAJJAR_WEB_SERVICE:-NAJJAR-Auto-Ads-Web}"

if [[ -z "${RAILWAY_TOKEN:-}" ]]; then
  echo "RAILWAY_TOKEN is required"
  exit 1
fi

export RAILWAY_TOKEN

service_exists() {
  local name="$1"
  $CLI service list -p "$PROJECT" -e "$ENV" --json 2>/dev/null | grep -q "\"name\":\"${name}\""
}

ensure_service() {
  local name="$1"
  if service_exists "$name"; then
    echo "Service exists: $name"
    return 0
  fi
  echo "Creating service: $name"
  $CLI add --service "$name" -p "$PROJECT" -e "$ENV" --json >/dev/null
}

ensure_mongo() {
  if service_exists "$MONGO_SVC"; then
    echo "MongoDB service exists: $MONGO_SVC"
    return 0
  fi
  echo "Adding MongoDB..."
  $CLI add --database mongo -s "$MONGO_SVC" -p "$PROJECT" -e "$ENV" --json >/dev/null || \
    $CLI add --database mongo -p "$PROJECT" -e "$ENV" --json >/dev/null
}

ensure_domain() {
  local svc="$1"
  if $CLI domain list -s "$svc" -p "$PROJECT" -e "$ENV" --json 2>/dev/null | grep -q '"domain"'; then
    $CLI domain list -s "$svc" -p "$PROJECT" -e "$ENV" --json
    return 0
  fi
  echo "Generating domain for $svc"
  $CLI domain -s "$svc" -p "$PROJECT" -e "$ENV" --json
}

get_domain() {
  local svc="$1"
  $CLI domain list -s "$svc" -p "$PROJECT" -e "$ENV" --json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    items = data if isinstance(data, list) else data.get('domains', data.get('items', []))
    for d in items:
        dom = d.get('domain') or d.get('host') or d.get('url')
        if dom:
            print(dom.replace('https://','').replace('http://','').rstrip('/'))
            break
except Exception:
    pass
"
}

JWT_SECRET="${NAJJAR_JWT_SECRET:-$(openssl rand -hex 24)}"

echo "=== NAJJAR Auto Ads Railway deploy ==="
ensure_mongo
ensure_service "$API_SVC"
ensure_service "$WEB_SVC"

echo "Configuring API variables..."
$CLI variable set \
  MONGODB_URI='${{'"${MONGO_SVC}"'.MONGO_URL}}' \
  JWT_SECRET="$JWT_SECRET" \
  DEMO_ADMIN_EMAIL="admin@najjar.om" \
  DEMO_ADMIN_PASSWORD="Najjar2026!" \
  NODE_ENV="production" \
  --service "$API_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null

echo "Deploying API..."
cd "$ROOT/integrations/najjar-auto-ads/backend"
$CLI up --detach -s "$API_SVC" -p "$PROJECT" -e "$ENV"

ensure_domain "$API_SVC" >/dev/null || true
API_HOST="$(get_domain "$API_SVC")"
if [[ -z "$API_HOST" ]]; then
  API_HOST="najjar-auto-ads-api-production.up.railway.app"
fi
API_URL="https://${API_HOST}/api"
echo "API URL: $API_URL"

echo "Configuring Web variables..."
$CLI variable set \
  VITE_API_BASE_URL="$API_URL" \
  --service "$WEB_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null

ensure_domain "$WEB_SVC" >/dev/null || true
WEB_HOST="$(get_domain "$WEB_SVC")"
if [[ -n "$WEB_HOST" ]]; then
  WEB_ORIGIN="https://${WEB_HOST}"
  $CLI variable set CORS_ORIGIN="$WEB_ORIGIN,http://localhost:3000" \
    --service "$API_SVC" -p "$PROJECT" -e "$ENV" --skip-deploys --json >/dev/null
fi

echo "Deploying Web..."
cd "$ROOT/integrations/najjar-auto-ads/frontend"
$CLI up --detach -s "$WEB_SVC" -p "$PROJECT" -e "$ENV"

WEB_HOST="$(get_domain "$WEB_SVC")"
if [[ -z "$WEB_HOST" ]]; then
  WEB_HOST="najjar-auto-ads-web-production.up.railway.app"
fi

echo ""
echo "=== Deploy complete ==="
echo "Web:  https://${WEB_HOST}"
echo "API:  ${API_URL}"
echo "Login: admin@najjar.om / Najjar2026!"
