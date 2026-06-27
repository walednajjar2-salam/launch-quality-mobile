"""Shared employee roster and policies folder paths."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


@dataclass
class Employee:
    role_number: int
    job_title: str
    name: str
    nationality: str = ""


EMPLOYEES: list[Employee] = [
    Employee(6, "المدير العام", "يعقوب فاضل الخصيبي"),
    Employee(7, "منسق المدير العام والشؤون الإدارية للموظفين", "أحمد محمد النجار", "أردني"),
    Employee(2, "موظفة الاستقبال", "عهود سعيد الشعيلي", "عمانية"),
    Employee(3, "مسؤولة قسم التسويق والتصميم", "رزان سالم الشهيلي", "عمانية"),
    Employee(1, "المحاسب", "وليد محمد النجار", "أردني"),
    Employee(4, "مدير إدارة الضيافة وتنظيم الحفلات", "علي محمد", "يمني"),
    Employee(5, "مدير إدارة العلاقات والعقارات", "__________________", "سوداني"),
]


def _repo_finance_dir() -> Path:
    return Path(__file__).resolve().parent.parent / "documents" / "جودة الانطلاقة" / "المالية"


def employ_dir() -> Path:
    repo_employ = _repo_finance_dir() / "employ"
    if (repo_employ / "Templet.docx").exists():
        return repo_employ
    candidates: list[Path] = [Path(r"D:\qulaty of lunch\employ")]
    desktop = Path.home() / "OneDrive/Desktop"
    if desktop.exists():
        for folder in desktop.iterdir():
            if folder.is_dir():
                candidates.append(folder / "qulaty of lunch" / "employ")
    for path in candidates:
        if (path / "Templet.docx").exists():
            return path
    repo_employ.mkdir(parents=True, exist_ok=True)
    return repo_employ


def template_path() -> Path:
    return employ_dir() / "Templet.docx"


def employee_files_dir() -> Path:
    out = _repo_finance_dir() / "ملفات-الموظفين"
    out.mkdir(parents=True, exist_ok=True)
    return out


def custody_files_dir() -> Path:
    out = employee_files_dir() / "عهدة"
    out.mkdir(parents=True, exist_ok=True)
    return out


def finance_templates_dir() -> Path:
    out = _repo_finance_dir() / "قوالب-رسمية"
    out.mkdir(parents=True, exist_ok=True)
    return out
