#!/usr/bin/env python3
"""Restore production ERP from a local flash-drive backup (export.json + optional sqlite).

Usage (after copying files from USB to your machine):

  export LQ_BACKUP_JSON="/path/to/export.json"
  export LQ_SQLITE="/path/to/jawdah.sqlite3"   # optional — keeps password hashes
  export LQ_RESTORE_MODE="replace"             # or "merge" (default)
  python3 scripts/restore-from-flash-backup.py

Typical flash-drive files:
  - export.json / jawdah-YYYYMMDD.json
  - jawdah.sqlite3
  - launch-quality-mobile-v1.1.zip  → redeploy Flutter (not handled here)
"""
from __future__ import annotations

import json
import os
import sqlite3
import sys
import urllib.error
import urllib.request

API = os.environ.get("LQ_API", "https://web-production-08d73.up.railway.app/api").rstrip("/")
BACKUP_JSON = os.environ.get("LQ_BACKUP_JSON", "").strip()
SQLITE_PATH = os.environ.get("LQ_SQLITE", "").strip()
MODE = os.environ.get("LQ_RESTORE_MODE", "merge").strip().lower()
ADMIN_USER = os.environ.get("LQ_ADMIN_USER", "admin")
ADMIN_PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "1234567891")


def request(method: str, path: str, token: str | None = None, body: dict | None = None) -> dict:
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(f"{API}/{path.lstrip('/')}", data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=300) as resp:
        return json.loads(resp.read().decode("utf-8"))


def load_tables(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        payload = json.load(f)
    if "tables" in payload:
        return payload["tables"]
    if isinstance(payload, dict) and any(isinstance(v, list) for v in payload.values()):
        return payload
    raise ValueError("Unrecognized backup JSON — expected {tables: {...}} or flat table map")


def enrich_users_from_sqlite(tables: dict) -> None:
    if not SQLITE_PATH or not os.path.isfile(SQLITE_PATH):
        return
    conn = sqlite3.connect(SQLITE_PATH)
    conn.row_factory = sqlite3.Row
    by_id = {r["id"]: dict(r) for r in conn.execute("SELECT * FROM users")}
    by_name = {r["username"]: dict(r) for r in by_id.values()}
    conn.close()
    merged = 0
    for user in tables.get("users") or []:
        src = by_id.get(user.get("id")) or by_name.get(user.get("username"))
        if not src or not src.get("password_hash"):
            continue
        user["password_hash"] = src["password_hash"]
        for field in ("must_change_password", "password_changed_at", "email"):
            if field in src and src[field] is not None:
                user[field] = src[field]
        merged += 1
    print(f"Enriched {merged} users from SQLite")


def main() -> int:
    if not BACKUP_JSON:
        print("Set LQ_BACKUP_JSON to your flash-drive export.json path.", file=sys.stderr)
        return 1
    if not os.path.isfile(BACKUP_JSON):
        print(f"File not found: {BACKUP_JSON}", file=sys.stderr)
        return 1

    tables = load_tables(BACKUP_JSON)
    enrich_users_from_sqlite(tables)
    counts = {k: len(v) for k, v in tables.items() if isinstance(v, list)}
    print(f"Loaded backup: {BACKUP_JSON}")
    print("Counts:", counts)

    login = request("POST", "login", body={"username": ADMIN_USER, "password": ADMIN_PASSWORD})
    if not login.get("ok"):
        print("Login failed:", login, file=sys.stderr)
        return 1
    token = login["token"]
    print(f"Restoring mode={MODE} to {API}")

    result = request(
        "POST",
        "restore",
        token=token,
        body={"mode": MODE, "backup": {"tables": tables}},
    )
    if not result.get("ok"):
        print("Restore failed:", result, file=sys.stderr)
        return 1

    after = request("GET", "bootstrap", token=token)["data"]
    print(
        "After:",
        f"properties={len(after.get('properties', []))}",
        f"contracts={len(after.get('contracts', []))}",
        f"clients={len(after.get('clients', []))}",
        f"users={len(after.get('users', []))}",
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        raise SystemExit(1)
