#!/usr/bin/env python3
"""Package finance/HR documents into documents/جودة الانطلاقة/المالية for upload."""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from employee_roster import _repo_finance_dir

REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS = REPO_ROOT / "documents"

ASSETS = [
    "logo-3d-badge.png",
    "logo-3d-gold.png",
    "letterhead-gold-header.png",
    "letterhead-gold-footer.png",
    "letterhead-header-source.png",
    "gold-letterhead-source.png",
]

TEMPLATES = [
    "QLP-Official-Template.docx",
    "lq-contract-template.docx",
    "lq-invoice-template.docx",
    "lq-official-letter.docx",
    "Emplooy-Premium.docx",
]


def main() -> None:
    base = _repo_finance_dir()
    assets_dir = base / "أصول-التصميم"
    templates_dir = base / "قوالب-رسمية"
    employ_dir = base / "employ"
    scripts_dir = base / "سكربتات"

    for folder in (assets_dir, templates_dir, employ_dir, scripts_dir):
        folder.mkdir(parents=True, exist_ok=True)

    for name in ASSETS:
        src = DOCS / name
        if src.exists():
            shutil.copy2(src, assets_dir / name)

    for name in TEMPLATES:
        src = DOCS / name
        if src.exists():
            shutil.copy2(src, templates_dir / name)

    src_tpl = Path(r"D:\qulaty of lunch\employ\Templet.docx")
    if not src_tpl.exists():
        for hit in (REPO_ROOT / "documents").rglob("Templet.docx"):
            src_tpl = hit
            break
    if src_tpl.exists():
        shutil.copy2(src_tpl, employ_dir / "Templet.docx")

    duties = Path(r"D:\qulaty of lunch\employ\المهام والمسوليات والواجبات.docx")
    if duties.exists():
        shutil.copy2(duties, employ_dir / duties.name)

    extract = REPO_ROOT / "employ_extract.txt"
    if extract.exists():
        shutil.copy2(extract, base / "employ_extract.txt")

    script_names = [
        "employee_roster.py",
        "org_info.py",
        "letterhead_gold_docx.py",
        "letterhead_docx.py",
        "requirements-docs.txt",
        "generate-official-template-docx.py",
        "generate-legal-templates.py",
        "generate-employee-policy-files.py",
        "generate-employee-custody-forms.py",
        "generate-employee-responsibilities-docx.py",
        "package-finance-upload.py",
    ]
    scripts_src = Path(__file__).resolve().parent
    for name in script_names:
        src = scripts_src / name
        if src.exists():
            shutil.copy2(src, scripts_dir / name)

    print(f"Packaged: {base}")


if __name__ == "__main__":
    main()
