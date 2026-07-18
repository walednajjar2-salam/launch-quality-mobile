#!/usr/bin/env bash
# Delete the legacy v72 Railway service (web-production-08d73.up.railway.app)
# Requires a Project Token from the OLD Railway project (not Jawda-Al-Intilaqa).
set -euo pipefail

OLD_RAILWAY_TOKEN="${OLD_RAILWAY_TOKEN:?Set OLD_RAILWAY_TOKEN to the legacy project token}"
LEGACY_DOMAIN="${LEGACY_DOMAIN:-web-production-08d73.up.railway.app}"
GRAPHQL_URL="https://backboard.railway.com/graphql/v2"

gql() {
  curl -sS --request POST \
    --url "$GRAPHQL_URL" \
    --header "Project-Access-Token: $OLD_RAILWAY_TOKEN" \
    --header 'Content-Type: application/json' \
    --data "$1"
}

echo "Resolving legacy project..."
META=$(gql '{"query":"query { projectToken { projectId environmentId } }"}')
PROJECT_ID=$(echo "$META" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['projectToken']['projectId'])")
ENVIRONMENT_ID=$(echo "$META" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['projectToken']['environmentId'])")
echo "Project: $PROJECT_ID"
echo "Environment: $ENVIRONMENT_ID"

echo "Listing services..."
SERVICES=$(gql "$(python3 -c "import json; print(json.dumps({'query': 'query { project(id: \"%s\") { services { edges { node { id name } } } } }' % '$PROJECT_ID'}))")")
echo "$SERVICES" | python3 -m json.tool

SERVICE_ID=$(echo "$SERVICES" | python3 -c "
import sys, json
edges = json.load(sys.stdin)['data']['project']['services']['edges']
if len(edges) == 1:
    print(edges[0]['node']['id'])
elif edges:
    for e in edges:
        print(e['node']['id'])
    raise SystemExit('Multiple services — set SERVICE_ID manually')
else:
    raise SystemExit('No services found')
" 2>/dev/null || true)

SERVICE_ID="${SERVICE_ID:-${LEGACY_SERVICE_ID:-}}"
if [[ -z "$SERVICE_ID" ]]; then
  echo "Set LEGACY_SERVICE_ID and re-run, or delete the service from Railway dashboard."
  exit 1
fi

echo "Deleting service $SERVICE_ID ..."
RESULT=$(gql "$(python3 -c "import json; print(json.dumps({'query': 'mutation { serviceDelete(id: \"%s\", environmentId: \"%s\") }' % ('$SERVICE_ID', '$ENVIRONMENT_ID'))}")")
echo "$RESULT" | python3 -m json.tool
echo "Verify: curl -I https://$LEGACY_DOMAIN/"
