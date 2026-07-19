# NAJJAR Auto Ads Platform

منصة **مستقلة** لإعلانات السيارات — Express + React · عربي RTL · MongoDB على Railway.

> **ليست جزءاً من نظام العقارات (Launch Quality ERP).**  
> حسابات وقاعدة بيانات وروابط منفصلة بالكامل.

## الروابط

| | |
|--|--|
| **الموقع** | https://najjar-auto-ads-api-production.up.railway.app |
| **الدخول** | `admin@najjar.om` / `Najjar2026!` |

## نظام العقارات (منفصل — Launch Quality)

| | |
|--|--|
| **ERP** | https://jawda-al-intilaqa-production.up.railway.app |
| **Staff Web** | https://launch-quality-mobile-production-bb40.up.railway.app |

## البنية

```
integrations/najjar-auto-ads/
├── backend/          Express + TypeScript + MongoDB
├── frontend/         React + Vite + RTL Arabic UI
├── docker-compose.yml
└── .env.example
```

## تشغيل سريع (Docker)

```bash
cd integrations/najjar-auto-ads
docker compose up -d
```

| الخدمة | الرابط |
|--------|--------|
| الواجهة | http://localhost:3000 |
| API | http://localhost:4000/api/health |
| Mongo Express | http://localhost:8081 |

**حساب تجريبي:** `admin@najjar.om` / `Najjar2026!`

## تشغيل يدوي

```bash
# Backend
cd backend && npm install && npm run dev

# Frontend (terminal جديد)
cd frontend && npm install && npm run dev
```

## API

| Method | Path | الوصف |
|--------|------|--------|
| POST | `/api/auth/register` | تسجيل |
| POST | `/api/auth/login` | دخول |
| GET | `/api/auth/me` | المستخدم الحالي |
| GET | `/api/ads` | قائمة الإعلانات |
| POST | `/api/ads` | إنشاء إعلان |
| PUT | `/api/ads/:id` | تحديث |
| DELETE | `/api/ads/:id` | حذف |
| POST | `/api/ads/:id/like` | مفضلة |

## النشر على Railway

1. أضف **MongoDB** plugin في مشروع Jawda-Al-Intilaqa
2. أنشئ خدمتين:
   - `NAJJAR-Auto-Ads-API` (Dockerfile: `backend/`)
   - `NAJJAR-Auto-Ads-Web` (Dockerfile: `frontend/`)
3. Backend variables: `MONGODB_URI`, `JWT_SECRET`, `CORS_ORIGIN`
4. Frontend build arg: `VITE_API_BASE_URL=https://<api-domain>/api`
5. GitHub Actions: `Deploy NAJJAR Auto Ads` (يتطلب `RAILWAY_TOKEN`)

## الاختبارات

```bash
cd backend && npm test
```

---

**Launch Quality LLC · NAJJAR Auto Ads v1.0.0**

