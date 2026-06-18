# إصلاح شعار iPhone (Add to Home Screen)

## المشكلة
عند **Add to Home Screen** على iPhone، Safari يبحث عن:
- `apple-touch-icon.png`
- `manifest.webmanifest`

هذه الملفات **لم تكن موجودة** على Production → يظهر مربع فارغ بدل الشعار.

## الحل (5 دقائق على GitHub)

1. افتح: https://github.com/walednajjar2-salam/jawdah-cloud-v47
2. ارفع ملفات من مجلد `pwa-ios-fix/public/` إلى `public/` في المستودع:
   - `apple-touch-icon.png`
   - `icon-192.png`
   - `icon-512.png`
   - `favicon-32.png`
   - `favicon.ico`
   - `manifest.webmanifest`
3. عدّل `public/index.html` — أضف في `<head>` (قبل `app.css`):

```html
  <meta name="theme-color" content="#1e293b">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="apple-mobile-web-app-title" content="Launch Quality">
  <link rel="icon" href="/favicon.ico" sizes="any">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="manifest" href="/manifest.webmanifest">
```

4. انتظر **Railway** يعيد النشر (1–3 دقائق)
5. على iPhone:
   - **احذف** الاختصار القديم من الشاشة الرئيسية
   - Safari → https://web-production-08d73.up.railway.app
   - Share ⬆️ → **Add to Home Screen** من جديد

## تحقق

```bash
curl -o /dev/null -w "%{http_code}\n" https://web-production-08d73.up.railway.app/apple-touch-icon.png
```

يجب أن يظهر: `200`

## تنزيل الأيقونات

https://github.com/walednajjar2-salam/-/tree/main/pwa-ios-fix/public
