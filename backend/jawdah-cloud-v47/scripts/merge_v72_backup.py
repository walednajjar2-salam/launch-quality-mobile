#!/usr/bin/env python3
"""Merge v72 backup JSON (+ password hashes from SQLite) into production via /api/restore."""
from __future__ import annotations

import json
import os
import sqlite3
import sys
import urllib.error
import urllib.request

API = os.environ.get("LQ_API", "https://jawda-al-intilaqa-production.up.railway.app/api").rstrip("/")
BACKUP_JSON = os.environ.get("LQ_BACKUP_JSON", "/tmp/lq-backup-merge.json")
SQLITE_PATH = os.environ.get("LQ_SQLITE", "/tmp/old.sqlite3")
MODE = os.environ.get("LQ_RESTORE_MODE", "merge")
USERNAME = os.environ.get("LQ_ADMIN_USER", "admin")
PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "Waleed2026!")

# Master/reference tables use UNIQUE natural keys (code) — skip when prod already seeded.
SKIP_TABLES = {
    "branches",
    "chart_accounts",
    "financial_periods",
    "collection_reminders",
    "employees",
}


def request(method: str, path: str, token: str | None = None, body: dict | None = None) -> dict:
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(f"{API}/{path.lstrip('/')}", data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode("utf-8"))


def enrich_users_from_sqlite(tables: dict) -> None:
    if not os.path.isfile(SQLITE_PATH):
        print(f"SQLite not found: {SQLITE_PATH}", file=sys.stderr)
        return
    conn = sqlite3.connect(SQLITE_PATH)
    conn.row_factory = sqlite3.Row
    rows_by_id = {r["id"]: dict(r) for r in conn.execute("SELECT * FROM users")}
    rows_by_user = {r["username"]: dict(r) for r in rows_by_id.values()}
    conn.close()
    users = tables.get("users") or []
    merged = 0
    for user in users:
        src = rows_by_id.get(user.get("id")) or rows_by_user.get(user.get("username"))
        if not src:
            continue
        if src.get("password_hash"):
            user["password_hash"] = src["password_hash"]
            merged += 1
        for field in ("must_change_password", "password_changed_at", "email"):
            if field in src and src[field] is not None:
                user[field] = src[field]
    print(f"Enriched {merged}/{len(users)} users with password_hash from SQLite")


def remap_branches(tables: dict, prod_tables: dict) -> None:
    """Avoid UNIQUE(code) conflicts by skipping branch rows and remapping branch_id references."""
    backup_branches = tables.pop("branches", []) or []
    prod_branches = prod_tables.get("branches") or []
    by_code = {b.get("code"): b.get("id") for b in prod_branches if b.get("code")}
    id_map = {}
    for branch in backup_branches:
        code = branch.get("code")
        prod_id = by_code.get(code)
        if prod_id and branch.get("id"):
            id_map[branch["id"]] = prod_id
    if not id_map:
        return
    for table, items in tables.items():
        if not isinstance(items, list):
            continue
        for item in items:
            if not isinstance(item, dict):
                continue
            bid = item.get("branch_id")
            if bid in id_map:
                item["branch_id"] = id_map[bid]
    print(f"Remapped branch IDs for {len(id_map)} branch code(s); skipped branches restore")


def filter_merge_tables(tables: dict, prod_tables: dict) -> dict:
    filtered = {}
    for table, items in tables.items():
        if table in SKIP_TABLES:
            continue
        if not isinstance(items, list):
            continue
        if table in prod_tables and table in ("chart_accounts",):
            continue
        filtered[table] = items
    skipped = sorted(set(tables.keys()) - set(filtered.keys()))
    print(f"Restoring {len(filtered)} tables (skipped: {', '.join(skipped) or 'none'})")
    return filtered


def main() -> int:
    with open(BACKUP_JSON, encoding="utf-8") as f:
        payload = json.load(f)
    backup = payload.get("backup") or payload
    tables = backup.get("tables", backup if isinstance(backup, dict) else payload)
    enrich_users_from_sqlite(tables)

    login = request("POST", "login", body={"username": USERNAME, "password": PASSWORD})
    if not login.get("ok"):
        print("Login failed:", login, file=sys.stderr)
        return 1
    token = login["token"]
    print(f"Logged in as {login.get('user', {}).get('username')}")

    before = request("GET", "bootstrap", token=token)
    data_before = before.get("data", {})
    remap_branches(tables, data_before)
    tables = filter_merge_tables(tables, data_before)
    for key in ("clients", "properties", "contracts", "invoices", "users"):
        print(f"Before {key}: {len(data_before.get(key, []))}")

    result = request("POST", "restore", token=token, body={"backup": {"tables": tables}, "mode": MODE})
    if not result.get("ok"):
        print("Restore failed:", result, file=sys.stderr)
        return 1
    print(f"Restore mode={MODE} OK")

    after = request("GET", "bootstrap", token=token)
    data_after = after.get("data", {})
    for key in ("clients", "properties", "contracts", "invoices", "users"):
        print(f"After {key}: {len(data_after.get(key, []))}")

    owner = request("POST", "login", body={"username": "waleed.najjar", "password": PASSWORD})
    print(f"waleed.najjar login: {owner.get('ok')}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        print(f"HTTP {exc.code}: {body}", file=sys.stderr)
        raise SystemExit(1)
