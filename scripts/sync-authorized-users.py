#!/usr/bin/env python3
"""Sync production ERP to the authorized 13-user roster only."""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request

API = os.environ.get("LQ_API", "https://web-production-08d73.up.railway.app/api").rstrip("/")
ADMIN_USER = os.environ.get("LQ_ADMIN_USER", "admin")
ADMIN_PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "1234567891")

AUTHORIZED = {
    "accountant": {"password": "1234567890", "name": "محمد سجاد حسين", "role": "viewer"},
    "admin": {"password": "1234567891", "name": "System Admin", "role": "admin"},
    "ahmed.najjar": {"password": "1234567892", "name": "أحمد محمد النجار", "role": "admin"},
    "ahoud.shuaili": {"password": "1234567893", "name": "عهود سعيد الشعيلي", "role": "operations"},
    "ali.hospitality": {"password": "1234567894", "name": "علي محمد النديش", "role": "maintenance"},
    "maintenance": {"password": "1234567895", "name": "محمد صالح سراج النور", "role": "viewer"},
    "operations": {"password": "1234567896", "name": "محمد مجدول أسلم", "role": "viewer"},
    "owner": {"password": "1234567897", "name": "يعقوب فاضل حمد الخصيبي", "role": "owner"},
    "properties.manager": {"password": "1234567898", "name": "امجد محمد الجامودي", "role": "operations"},
    "razan.accounting": {"password": "1234567899", "name": "محمد بو فايز", "role": "viewer"},
    "razan.shuaili": {"password": "1234567900", "name": "رزان سالم الشعيلي", "role": "accountant"},
    "viewer": {"password": "1234567901", "name": "محمد فاروق حمد شافي", "role": "operations"},
    "waleed.najjar": {"password": "1234567902", "name": "وليد محمد النجار", "role": "owner"},
}

DISABLED = ("Ahmad.najjar", "hospitality", "Account", "Real Estate")


def request(method: str, path: str, token: str | None = None, body: dict | None = None) -> dict:
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(f"{API}/{path.lstrip('/')}", data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode("utf-8"))


def main() -> int:
    login = request("POST", "login", body={"username": ADMIN_USER, "password": ADMIN_PASSWORD})
    if not login.get("ok"):
        print("Login failed:", login, file=sys.stderr)
        return 1
    token = login["token"]

    users = request("GET", "bootstrap", token=token)["data"]["users"]
    by_name = {u["username"]: u for u in users}

    for username, spec in AUTHORIZED.items():
        row = by_name.get(username)
        if not row:
            print(f"Missing user: {username}", file=sys.stderr)
            return 1
        result = request(
            "PUT",
            f"users/{row['id']}",
            token=token,
            body={
                "username": username,
                "name": spec["name"],
                "role": spec["role"],
                "active": True,
                "password": spec["password"],
            },
        )
        if not result.get("ok"):
            print(f"Update failed: {username}", result, file=sys.stderr)
            return 1
        print(f"OK {username}")

    for username in DISABLED:
        row = by_name.get(username)
        if not row:
            continue
        request(
            "PUT",
            f"users/{row['id']}",
            token=token,
            body={"username": username, "name": row.get("name"), "role": row.get("role"), "active": False},
        )
        print(f"DISABLED {username}")

    ok = 0
    for username, spec in AUTHORIZED.items():
        r = request("POST", "login", body={"username": username, "password": spec["password"]})
        if r.get("ok") and r["user"]["name"] == spec["name"]:
            ok += 1
        else:
            print(f"Verify failed: {username}", file=sys.stderr)

    blocked = True
    for username in DISABLED:
        try:
            r = request("POST", "login", body={"username": username, "password": "1234567891"})
            if r.get("ok"):
                blocked = False
                print(f"Still active: {username}", file=sys.stderr)
        except urllib.error.HTTPError:
            pass

    print(f"Authorized logins: {ok}/{len(AUTHORIZED)}")
    return 0 if ok == len(AUTHORIZED) and blocked else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        raise SystemExit(1)
