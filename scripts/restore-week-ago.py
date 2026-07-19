#!/usr/bin/env python3
"""Restore ERP operational data from ~1 week ago (2026-07-12) backup."""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request

API = os.environ.get("LQ_API", "https://web-production-08d73.up.railway.app/api").rstrip("/")
ADMIN_USER = os.environ.get("LQ_ADMIN_USER", "admin")
ADMIN_PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "1234567891")
BACKUP_TS = os.environ.get("LQ_BACKUP_TS", "20260712-042029")

# Keep current authorized roster — do not restore week-old users
KEEP_USERS = True
WEEK_AGO_PROP_IDS = {
    "P-1001",
    "P-1003",
    "PRO-0BC035B7",
    "PRO-1619E470",
    "PRO-28199DB2",
}


def request(method: str, path: str, token: str | None = None, body: dict | None = None) -> dict:
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(f"{API}/{path.lstrip('/')}", data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=180) as resp:
        return json.loads(resp.read().decode("utf-8"))


def download_backup(token: str) -> dict:
    req = urllib.request.Request(
        f"{API}/backup/download?kind=json&timestamp={BACKUP_TS}",
        headers={"Authorization": f"Bearer {token}"},
    )
    with urllib.request.urlopen(req, timeout=180) as resp:
        payload = json.loads(resp.read().decode("utf-8"))
    return payload.get("tables", payload)


def main() -> int:
    login = request("POST", "login", body={"username": ADMIN_USER, "password": ADMIN_PASSWORD})
    if not login.get("ok"):
        print("Login failed:", login, file=sys.stderr)
        return 1
    token = login["token"]
    print(f"Logged in — restoring backup {BACKUP_TS}")

    tables = download_backup(token)
    restore = {
        "properties": tables.get("properties") or [],
        "contracts": tables.get("contracts") or [],
        "clients": tables.get("clients") or [],
        "invoices": tables.get("invoices") or [],
        "maintenance": tables.get("maintenance") or [],
        "accounts": tables.get("accounts") or [],
        "payments": tables.get("payments") or [],
        "purchase_invoices": tables.get("purchase_invoices") or [],
        "revenues": tables.get("revenues") or [],
    }
    print(
        "Week-ago counts:",
        {k: len(v) for k, v in restore.items()},
    )

    # Merge week-ago operational tables (users untouched)
    result = request(
        "POST",
        "restore",
        token=token,
        body={"mode": "merge", "backup": {"tables": restore}},
    )
    if not result.get("ok"):
        print("Restore failed:", result, file=sys.stderr)
        return 1
    print("Merge restore OK")

    # Remove seed properties that did not exist a week ago
    current = request("GET", "bootstrap", token=token)["data"]["properties"]
    for p in current:
        pid = p.get("id")
        if pid and pid not in WEEK_AGO_PROP_IDS:
            try:
                request("DELETE", f"properties/{pid}", token=token)
                print(f"Removed later property: {pid}")
            except urllib.error.HTTPError as exc:
                print(f"Could not delete {pid}: {exc.code}")

    after = request("GET", "bootstrap", token=token)["data"]
    print(
        "After:",
        f"properties={len(after.get('properties', []))}",
        f"contracts={len(after.get('contracts', []))}",
        f"clients={len(after.get('clients', []))}",
        f"users={len(after.get('users', []))}",
    )
    print("Properties:")
    for p in after.get("properties", []):
        print(f"  {p['id']} | {p.get('status')} | {p.get('name', '')[:40]}")

    # Verify admin still works
    check = request("POST", "login", body={"username": "admin", "password": ADMIN_PASSWORD})
    print("Admin login after restore:", check.get("ok"))
    return 0 if check.get("ok") else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        raise SystemExit(1)
