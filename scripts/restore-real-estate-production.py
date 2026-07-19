#!/usr/bin/env python3
"""Restore Launch Quality real estate data on production — fix contracts/properties/users."""
from __future__ import annotations

import hashlib
import json
import os
import secrets
import sys
import urllib.error
import urllib.request
from datetime import date, timedelta

API = os.environ.get("LQ_API", "https://jawda-al-intilaqa-production.up.railway.app/api").rstrip("/")
ADMIN_USER = os.environ.get("LQ_ADMIN_USER", "waleed.najjar")
ADMIN_PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "1234567902")
BACKUP_TS = os.environ.get("LQ_BACKUP_TS", "20260719-062159")

ACTIVE_USERS = [
    ("accountant", "1234567890"),
    ("admin", "1234567891"),
    ("ahmed.najjar", "1234567892"),
    ("ahoud.shuaili", "1234567893"),
    ("ali.hospitality", "1234567894"),
    ("maintenance", "1234567895"),
    ("operations", "1234567896"),
    ("owner", "1234567897"),
    ("properties.manager", "1234567898"),
    ("razan.accounting", "1234567899"),
    ("razan.shuaili", "1234567900"),
    ("viewer", "1234567901"),
    ("waleed.najjar", "1234567902"),
]

DISABLE_USERNAMES = {"Ahmad.najjar", "hospitality", "Account", "Real Estate"}


def password_hash(password: str, salt: str | None = None) -> str:
    salt = salt or secrets.token_hex(16)
    dk = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt.encode("ascii"), 120000)
    return f"pbkdf2_sha256${salt}${dk.hex()}"


def request(method: str, path: str, token: str | None = None, body: dict | None = None) -> dict:
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(f"{API}/{path.lstrip('/')}", data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode("utf-8"))


def load_backup(token: str) -> dict:
    req = urllib.request.Request(
        f"{API}/backup/download?kind=json&timestamp={BACKUP_TS}",
        headers={"Authorization": f"Bearer {token}"},
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        payload = json.loads(resp.read().decode("utf-8"))
    return payload.get("tables", payload)


def fix_properties(properties: list) -> list:
    by_id = {p["id"]: p for p in properties}
    if "P-1001" in by_id:
        by_id["P-1001"]["status"] = "مستأجرة"
    if "P-1003" in by_id:
        by_id["P-1003"]["status"] = "صيانة"
    if "PRO-0BC035B7" in by_id:
        by_id["PRO-0BC035B7"]["status"] = "مستأجرة"
    if "PRO-1619E470" in by_id:
        by_id["PRO-1619E470"]["status"] = "شاغرة"
    return list(by_id.values())


def fix_contracts(contracts: list) -> list:
    today = date.today().isoformat()
    end = (date.today() + timedelta(days=330)).isoformat()
    fixed = []
    for c in contracts:
        row = dict(c)
        cid = row.get("id")
        if cid == "CT-1001":
            row["status"] = "Active"
            row["property_id"] = "P-1001"
            row["start_date"] = row.get("start_date") or today
            row["end_date"] = row.get("end_date") or end
            row["approved_at"] = row.get("approved_at") or f"{today} 12:00:00"
        elif cid == "CON-1AFA6260":
            row["status"] = "Active"
            row["approved_at"] = row.get("approved_at") or f"{today} 12:00:00"
        elif cid in {"CON-BEA9E1C9", "CON-92A320AE", "CON-38E2C278"}:
            row["status"] = "Cancelled"
        fixed.append(row)
    return fixed


def fix_users(users: list) -> list:
    pwd_map = {u: p for u, p in ACTIVE_USERS}
    fixed = []
    for user in users:
        row = dict(user)
        username = row.get("username")
        if username in DISABLE_USERNAMES:
            row["active"] = 0
        if username in pwd_map:
            row["active"] = 1
            row["password_hash"] = password_hash(pwd_map[username])
            row["must_change_password"] = 0
            row["password_changed_at"] = f"{date.today().isoformat()} 12:00:00"
        fixed.append(row)
    return fixed


def main() -> int:
    login = request("POST", "login", body={"username": ADMIN_USER, "password": ADMIN_PASSWORD})
    if not login.get("ok"):
        print("Login failed:", login, file=sys.stderr)
        return 1
    token = login["token"]
    print(f"Logged in as {login['user']['username']}")

    before = request("GET", "bootstrap", token=token)["data"]
    print(f"Before: properties={len(before.get('properties',[]))} contracts={len(before.get('contracts',[]))}")

    tables = load_backup(token)
    restore_tables = {
        "properties": fix_properties(tables.get("properties") or []),
        "contracts": fix_contracts(tables.get("contracts") or []),
        "users": fix_users(tables.get("users") or []),
        "clients": tables.get("clients") or [],
        "invoices": tables.get("invoices") or [],
        "maintenance": tables.get("maintenance") or [],
        "accounts": tables.get("accounts") or [],
        "payments": tables.get("payments") or [],
    }

    result = request(
        "POST",
        "restore",
        token=token,
        body={"mode": "merge", "backup": {"tables": restore_tables}},
    )
    if not result.get("ok"):
        print("Restore failed:", result, file=sys.stderr)
        return 1
    print("Restore OK")

    after = request("GET", "bootstrap", token=token)["data"]
    print(f"After: properties={len(after.get('properties',[]))} contracts={len(after.get('contracts',[]))}")
    print("Active contracts:")
    for c in after.get("contracts", []):
        if c.get("status") == "Active":
            print(f"  {c['id']} -> {c.get('property_id')}")

    ok_count = 0
    for username, pwd in ACTIVE_USERS:
        r = request("POST", "login", body={"username": username, "password": pwd})
        if r.get("ok"):
            ok_count += 1
        else:
            print(f"Login failed: {username}", file=sys.stderr)
    print(f"Verified logins: {ok_count}/{len(ACTIVE_USERS)}")
    return 0 if ok_count == len(ACTIVE_USERS) else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        raise SystemExit(1)
