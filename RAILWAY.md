# نشر تطبيق جودة الانطلاقة (Flutter Web) على Railway

## المتطلبات
- حساب Railway مربوط بـ GitHub
- المستودع: `walednajjar2-salam/launch-quality-mobile`

## النشر من لوحة Railway (موصى به)

1. افتح https://railway.app/new
2. **Deploy from GitHub repo** → اختر `launch-quality-mobile`
3. تأكد أن الإعدادات:
   - Builder: **Dockerfile** (موجود في الجذر)
   - Healthcheck: `/`
4. **Settings → Networking → Generate Domain**
5. افتح الرابط الناتج وسجّل الدخول بـ:
   - المستخدم: `waleed.najjar`
   - كلمة المرور: `Waleed2026!`

التطبيق يتصل تلقائياً بـ API الإنتاج:
`https://jawda-al-intilaqa-production.up.railway.app/api`

## النشر من CLI

```bash
# مرة واحدة
railway login
railway init   # أو: railway link

# نشر
railway up
```

أو مع توكن مشروع:

```bash
export RAILWAY_TOKEN=...
railway up --detach
```

## ملاحظات
- صورة البناء تستخدم `ghcr.io/cirruslabs/flutter:stable` ثم `nginx:alpine`
- المنفذ يُضبط تلقائياً عبر متغير `PORT` من Railway
- لا حاجة لمتغيرات بيئة إضافية للتشغيل الأساسي

## Backend ERP (جودة الانطلاقة)

| الخدمة | الرابط |
|--------|--------|
| API | https://jawda-al-intilaqa-production.up.railway.app/api |
| ERP | https://jawda-al-intilaqa-production.up.railway.app/app.html |
| Volume | `jawda-al-intilaqa-volume` → `/app/data` (البيانات محفوظة بعد إعادة النشر) |

## Flutter Web (Staff)

| الخدمة | الرابط |
|--------|--------|
| Staff Web | https://launch-quality-mobile-production-bb40.up.railway.app |
| **تحميل Windows** | https://jawda-al-intilaqa-production.up.railway.app/downloads/Launch-Quality-Staff-Windows.zip |
| **تحميل Android** | https://jawda-al-intilaqa-production.up.railway.app/downloads/Launch-Quality-Staff.apk |
| صفحة التحميل | https://launch-quality-mobile-production-bb40.up.railway.app/download.html |
| Railway service | `Launch-Quality-Mobile` |

GitHub Actions: أضف `RAILWAY_TOKEN` — راجع `.github/DEPLOY.md`

## NAJJAR Auto Ads (إعلانات السيارات — **منفصل عن العقارات**)

منصة مستقلة — **لا تستخدم حسابات Launch Quality ERP**.

| الخدمة | الرابط |
|--------|--------|
| **الموقع + API** | https://najjar-auto-ads-api-production.up.railway.app |
| **الدخول** | `admin@najjar.om` / `Najjar2026!` |
| **قاعدة البيانات** | MongoDB (Railway) — منفصلة عن ERP |

التشغيل المحلي: `cd integrations/najjar-auto-ads && docker compose up -d`
