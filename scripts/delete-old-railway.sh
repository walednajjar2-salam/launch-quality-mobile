#!/usr/bin/env bash
# Delete legacy v72 Railway service. Supports workspace or project token.
set -euo pipefail
exec python3 "$(dirname "$0")/delete-old-railway.py"
