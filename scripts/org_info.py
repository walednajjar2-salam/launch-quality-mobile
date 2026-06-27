"""Official organization details — sourced from Launch Quality ERP / Railway deploy."""

ORG = {
    "name_ar": "مشاريع جودة الانطلاقة",
    "name_ar_legal": "جودة الانطلاقة ش.م.م",
    "name_en": "Quality of Launch Real Estate & Hospitality Services LLC",
    "name_en_short": "Launch Quality LLC",
    "tagline_ar": "لإدارة العقارات وخدمات الضيافة",
    "tagline_en": "Real Estate & Hospitality Services",
    "cr": "1466316",
    "postal": "611",
    "phones": ("+968 9220 0218", "+968 9212 0205"),
    "email": "jiwdat@gmail.com",
    "instagram": "@jiwdat.rec",
    "facebook": "jiwdat.hs",
    "website": "www.qualitylaunch.om",
    "location_ar": "حي التراث — نزوى، سلطنة عُمان",
    "location_en": "Hay Al Turath — Nizwa, Sultanate of Oman",
    "country_en": "Sultanate of Oman",
    "ref_prefix": "QLP",
    "backend": "https://web-production-08d73.up.railway.app",
}

CONTACT_LINE_EN = (
    f"{ORG['email']}   ·   {ORG['instagram']}   ·   {ORG['facebook']}   ·   "
    f"{ORG['phones'][0]}   ·   {ORG['phones'][1]}"
)

CONTACT_LINE_AR = (
    f"س.ت {ORG['cr']}   ·   ص.ب {ORG['postal']}   ·   "
    f"{ORG['location_ar']}"
)

FOOTER_LINE = (
    f"{ORG['name_ar']}  ·  {ORG['name_en_short']}  ·  "
    f"C.R. {ORG['cr']}  ·  {ORG['country_en']}"
)
