# Jawdah Cloud v39 Railway Fixed

هذه النسخة تصلح مشكلة Railway التي تظهر في اللوج كالتالي:

- `GET / HTTP/1.1 404`
- `File not found`
- `GET /favicon.ico 404`

## ما تم إصلاحه

- الرابط الرئيسي `/` يفتح الواجهة مباشرة.
- `/index.html` يعمل حتى لو لم يتم نسخ مجلد `public` في الاستضافة.
- `/app.css` و `/app.js` لديهما Fallback مدمج.
- `/favicon.ico` لا يسبب خطأ 404.
- `PORT` يتم أخذه تلقائياً من Railway.

## أمر التشغيل في Railway

```bash
python server.py
```

## رابط الفحص

```text
/api/health
```

## بيانات الدخول

- admin / admin123
- accountant / 1234
- operations / 1234
- maintenance / 1234
- viewer / 1234

بعد النشر غيّر كلمة مرور المدير.
