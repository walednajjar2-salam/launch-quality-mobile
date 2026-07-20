#!/usr/bin/env python3
"""Restore hotel/property photos + map-ready locations on ERP production."""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request

API = os.environ.get("LQ_API", "https://web-production-08d73.up.railway.app/api").rstrip("/")
ADMIN_USER = os.environ.get("LQ_ADMIN_USER", "admin")
ADMIN_PASSWORD = os.environ.get("LQ_ADMIN_PASSWORD", "1234567891")

# Curated hospitality / apartment photos (Unsplash — direct images)
HOTEL_PHOTOS = {
    "P-1001": {
        "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80",
        "type": "Villa",
        "location": "نزوى · حي التراث",
        "notes": "وحدة فندقية · نزوى | lat=22.9333,lng=57.5333",
    },
    "P-1002": {
        "image": "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80",
        "type": "Villa",
        "location": "Barka",
        "notes": "فيلا ضيافة · بركاء | lat=23.7070,lng=57.8890",
    },
    "P-1003": {
        "image": "https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80",
        "type": "Suite",
        "location": "نزوى · حي التراث",
        "notes": "جناح فندقي · نزوى | lat=22.9400,lng=57.5400",
    },
    "P-1004": {
        "image": "https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80",
        "type": "Apartment",
        "location": "Muscat",
        "notes": "شقة فندقية · مسقط | lat=23.5880,lng=58.3829",
    },
    "PRO-0BC035B7": {
        "image": "https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=80",
        "type": "Villa",
        "location": "نزوى · حي التراث",
        "notes": "وحدة ضيافة · نزوى | lat=22.9280,lng=57.5280",
    },
    "PRO-1619E470": {
        "image": "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=1200&q=80",
        "type": "Villa",
        "location": "نزوى · حي التراث",
        "notes": "جناح ضيافة · نزوى | lat=22.9450,lng=57.5350",
    },
    "PRO-28199DB2": {
        "image": "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80",
        "type": "Villa",
        "location": "نزوى · حي التراث",
        "notes": "وحدة ضيافة · نزوى | lat=22.9380,lng=57.5300",
    },
}


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

    props = request("GET", "bootstrap", token=token)["data"]["properties"]
    updated = []
    for p in props:
        pid = p["id"]
        patch = HOTEL_PHOTOS.get(pid)
        if not patch:
            continue
        row = dict(p)
        row.update(patch)
        updated.append(row)
        print(f"Photo: {pid} -> {patch['image'][:60]}...")

    if not updated:
        print("No matching properties", file=sys.stderr)
        return 1

    result = request(
        "POST",
        "restore",
        token=token,
        body={"mode": "merge", "backup": {"tables": {"properties": updated}}},
    )
    if not result.get("ok"):
        print("Restore failed:", result, file=sys.stderr)
        return 1

    after = request("GET", "bootstrap", token=token)["data"]["properties"]
    with_photos = sum(1 for p in after if str(p.get("image", "")).startswith("http"))
    print(f"Properties with hotel photos: {with_photos}/{len(after)}")
    return 0 if with_photos else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        raise SystemExit(1)
