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
