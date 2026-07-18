# إعداد صلاحيات Railway + GitHub لـ Cloud Agent

> **لا** تنشئ repo باسم `RAILWAY_TOKEN`  
> **لا** تضع التوken في `README.md` أو المحادثة — فقط GitHub Secrets

---

## خياران

| الخيار | متى تستخدمه | Secrets |
|--------|-------------|---------|
| **A — مشروع واحد** | نشر Jawda-Al-Intilaqa فقط | `RAILWAY_TOKEN` |
| **B — كل المشاريع** (موصى به لك) | حذف v72 + إدارة أي مشروع | `RAILWAY_WORKSPACE_TOKEN` + `RAILWAY_TOKEN` |

---

## B — كل مشاريع Railway (Workspace Token)

### 1) أنشئ Workspace Token

1. https://railway.app/account/tokens  
2. **Create Token**  
3. Workspace: **`walednajjar2-salam's Projects`**  
4. انسخ التوken (يظهر مرة واحدة)

### 2) أضف Secrets في GitHub

افتح: https://github.com/walednajjar2-salam/launch-quality-mobile/settings/secrets/actions

| Secret | القيمة | الغرض |
|--------|--------|--------|
| **`RAILWAY_WORKSPACE_TOKEN`** | Workspace Token من الخطوة 1 | Agent يدير **كل** المشاريع (حذف v72، listing، إلخ) |
| **`RAILWAY_TOKEN`** | Project Token من **Jawda-Al-Intilaqa** | GitHub Actions ينشر Backend + Flutter |
| **`OLD_RAILWAY_TOKEN`** | *(اختياري)* Project Token من v72 | حذف v72 فقط — أو استخدم Workspace بدلاً منه |

### 3) Cursor Cloud Agent (GitHub)

1. Repo → **Settings** → **Actions** → **General**  
   - Workflow permissions: **Read and write**
2. Repo → **Settings** → **Collaborators**  
   - Agent/Cursor: **Write** أو **Admin**
3. Cursor → Cloud Agent على **`launch-quality-mobile`** → branch **`main`**

### 4) بعد الإضافة

اكتب في Chat: **«التوkenات جاهزة»**

---

## مشاريعك المعروفة

| المشروع | Project ID | الدومين | الخدمات |
|---------|------------|---------|---------|
| **Jawda-Al-Intilaqa** | `9239907c-96e9-4763-b2d3-2d57931f7bba` | `jawda-al-intilaqa-production.up.railway.app` | Backend ERP + Flutter Web + Volume |
| **v72 القديم** | *(من لوحة Railway)* | `web-production-08d73.up.railway.app` | ERP قديم — **يُحذف** |
| **jawdah-cloud-v47** | repo GitHub منفصل | — | push يحتاج Collaborator على ذلك ال repo |

Environment ID (Jawda production): `1c648843-321c-4c22-a799-2cdbee50ad8e`

---

## ماذا يستطيع Agent بعد الإعداد

| المهمة | Secret |
|--------|--------|
| نشر Backend + Flutter (CI) | `RAILWAY_TOKEN` |
| حذف v72 / أي service | `RAILWAY_WORKSPACE_TOKEN` |
| فحص أمني لكل المشاريع | `RAILWAY_WORKSPACE_TOKEN` |
| إنشاء Volume / Domain | `RAILWAY_TOKEN` أو Workspace |
| إضافة GitHub Secrets | **أنت فقط** (Agent لا يصل — 403) |

---

## أوامر يدوية (بعد export)

```bash
# كل المشاريع — Workspace
export RAILWAY_TOKEN="$RAILWAY_WORKSPACE_TOKEN"
npx @railway/cli list

# حذف v72
export OLD_RAILWAY_TOKEN=...   # أو نفس Workspace token
bash scripts/delete-old-railway.sh

# نشر Jawda (Project token)
export RAILWAY_TOKEN=...       # Jawda-Al-Intilaqa project token
./scripts/deploy-jawdah-cloud.sh
./scripts/deploy-flutter-web.sh
```

---

## أمان

1. **دوّر** أي توken ظهر في Chat  
2. Workspace Token أقوى من Project Token — لا تشاركه  
3. بعد حذف v72 → احذف `OLD_RAILWAY_TOKEN` من GitHub  
4. راجع Tokens شهرياً: https://railway.app/account/tokens

---

## الحالة

- [x] `RAILWAY_TOKEN` — Jawda-Al-Intilaqa (2026-07-18)
- [ ] `RAILWAY_WORKSPACE_TOKEN` — كل المشاريع
- [ ] `OLD_RAILWAY_TOKEN` — v72 (اختياري إذا استخدمت Workspace)

---

## الروابط الحية

| الخدمة | الرابط |
|--------|--------|
| Backend API | https://jawda-al-intilaqa-production.up.railway.app/api |
| ERP | https://jawda-al-intilaqa-production.up.railway.app/app.html |
| Flutter Web | https://launch-quality-mobile-production-bb40.up.railway.app |
| v72 (يُحذف) | https://web-production-08d73.up.railway.app |
