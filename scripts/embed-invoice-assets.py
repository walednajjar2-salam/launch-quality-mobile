#!/usr/bin/env python3
"""Embed PNG assets as base64 so invoice HTML works standalone on phone."""
from __future__ import annotations

import base64
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXPORTS = ROOT / "assets" / "exports"

ASSETS = {
    "Barq_Al_Bihar_Logo.png": "image/png",
    "Barq_Al_Bihar_Stamp_Clean.png": "image/png",
}


def data_uri(path: Path, mime: str) -> str:
    return f"data:{mime};base64,{base64.b64encode(path.read_bytes()).decode()}"


def embed(html_path: Path) -> Path:
    text = html_path.read_text(encoding="utf-8")
    for filename, mime in ASSETS.items():
        uri = data_uri(EXPORTS / filename, mime)
        text = text.replace(f'src="{filename}"', f'src="{uri}"')
        text = text.replace(f"src='{filename}'", f"src='{uri}'")
        text = text.replace(f"url('{filename}')", f"url('{uri}')")
    out = html_path.with_name(html_path.stem + "-standalone.html")
    out.write_text(text, encoding="utf-8")
    print(f"Wrote {out.name} ({out.stat().st_size // 1024} KB)")
    return out


def main() -> None:
    for name in ("vehicle-purchase-invoice-usa.html", "bill-of-lading-shipping.html"):
        path = EXPORTS / name
        if not path.exists():
            print(f"Missing {path}", file=sys.stderr)
            sys.exit(1)
        embed(path)


if __name__ == "__main__":
    main()
