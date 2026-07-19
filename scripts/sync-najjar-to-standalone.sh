#!/usr/bin/env bash
# Sync integrations/najjar-auto-ads → walednajjar2-salam/NAJJAR-auto-ads (standalone repo).
# Triggered automatically when NAJJAR paths change on main.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/integrations/najjar-auto-ads"
DEST_REPO="${NAJJAR_STANDALONE_REPO:-https://github.com/walednajjar2-salam/NAJJAR-auto-ads.git}"
WORKDIR="$(mktemp -d)"

cleanup() { rm -rf "$WORKDIR"; }
trap cleanup EXIT

echo "=== Sync NAJJAR Auto Ads → standalone repo ==="
echo "Source: $SRC"
echo "Target: $DEST_REPO"

git clone --depth 1 "$DEST_REPO" "$WORKDIR/repo"
cd "$WORKDIR/repo"

tar cf - -C "$SRC" \
  --exclude='node_modules' \
  --exclude='backend/data' \
  --exclude='*.sqlite3' \
  --exclude='dist' \
  --exclude='backend/public' \
  . | tar xf -

mkdir -p scripts .github/workflows

sed 's|cd "\$ROOT/integrations/najjar-auto-ads"|cd "\$ROOT"|' \
  "$ROOT/scripts/deploy-najjar-auto-ads.sh" > scripts/deploy-railway.sh

chmod +x scripts/deploy-railway.sh

cat > .github/workflows/test.yml <<'YAML'
name: Test NAJJAR Auto Ads

on:
  workflow_dispatch:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: npm
          cache-dependency-path: backend/package-lock.json
      - run: npm install
      - run: npm test

  frontend-build:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm run build
        env:
          VITE_API_BASE_URL: /api
YAML

cat > .github/workflows/deploy-railway.yml <<'YAML'
name: Deploy NAJJAR Auto Ads to Railway

on:
  workflow_dispatch:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - 'frontend/**'
      - 'Dockerfile'
      - 'railway.toml'
      - 'scripts/deploy-railway.sh'
      - '.github/workflows/deploy-railway.yml'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Deploy NAJJAR Auto Ads
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
          RAILWAY_PROJECT_ID: 9239907c-96e9-4763-b2d3-2d57931f7bba
          RAILWAY_ENVIRONMENT: production
          NAJJAR_JWT_SECRET: ${{ secrets.NAJJAR_JWT_SECRET }}
        run: |
          if [ -z "$RAILWAY_TOKEN" ]; then
            echo "::warning::RAILWAY_TOKEN not set — skipping deploy"
            exit 0
          fi
          chmod +x scripts/deploy-railway.sh
          bash scripts/deploy-railway.sh
YAML

cat > README.md <<'MD'
# NAJJAR Auto Ads Platform

منصة احترافية لإعلانات السيارات — Express + React · عربي RTL · MongoDB على Railway.

**الإنتاج:** https://najjar-auto-ads-api-production.up.railway.app  
**حساب تجريبي:** `admin@najjar.om` / `Najjar2026!`

> المصدر الرئيسي: [launch-quality-mobile](https://github.com/walednajjar2-salam/launch-quality-mobile) → `integrations/najjar-auto-ads/`  
> هذا المستودع نسخة مستقلة متزامنة.

## البنية

\`\`\`
backend/     Express + TypeScript + MongoDB/SQLite
frontend/    React + Vite + RTL Arabic UI
Dockerfile   نشر موحّد (API + الواجهة)
\`\`\`

## تشغيل سريع

\`\`\`bash
docker compose up -d
# الواجهة: http://localhost:3000
# API: http://localhost:4000/api/health
\`\`\`

## الاختبارات

\`\`\`bash
cd backend && npm test
\`\`\`
MD

if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to sync."
  exit 0
fi

git add -A
git commit -m "chore: sync from launch-quality-mobile integrations/najjar-auto-ads"
git push origin main

echo "=== Sync complete ==="
