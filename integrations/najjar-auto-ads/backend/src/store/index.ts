import { getDb, nowIso, uid, type AdRow, type UserRow } from "../db.js";
import { hashPassword } from "../utils/auth.js";

export function findUserByEmail(email: string): UserRow | undefined {
  return getDb().prepare("SELECT * FROM users WHERE email = ?").get(email.toLowerCase()) as UserRow | undefined;
}

export function findUserById(id: string): UserRow | undefined {
  return getDb().prepare("SELECT * FROM users WHERE id = ?").get(id) as UserRow | undefined;
}

export function createUser(input: {
  name: string;
  email: string;
  passwordHash: string;
  phone?: string;
  role?: string;
}): UserRow {
  const row: UserRow = {
    id: uid("USR"),
    name: input.name,
    email: input.email.toLowerCase(),
    password_hash: input.passwordHash,
    phone: input.phone || "",
    role: input.role || "user",
    rating: 5,
    created_at: nowIso(),
  };
  getDb()
    .prepare(
      "INSERT INTO users (id,name,email,password_hash,phone,role,rating,created_at) VALUES (?,?,?,?,?,?,?,?)",
    )
    .run(row.id, row.name, row.email, row.password_hash, row.phone, row.role, row.rating, row.created_at);
  return row;
}

export function ensureDemoUser(): void {
  const email = (process.env.DEMO_ADMIN_EMAIL || "admin@najjar.om").toLowerCase();
  if (findUserByEmail(email)) return;
  createUser({
    name: "وليد نجار",
    email,
    passwordHash: hashPassword(process.env.DEMO_ADMIN_PASSWORD || "Najjar2026!"),
    phone: "+96871924089",
    role: "admin",
  });
}

export function listAds(filter: {
  q?: string;
  city?: string;
  make?: string;
  model?: string;
  minPrice?: number;
  maxPrice?: number;
  limit: number;
  offset: number;
}): { items: AdRow[]; total: number } {
  const where: string[] = ["status = 'active'"];
  const params: unknown[] = [];
  if (filter.q) {
    where.push("(title LIKE ? OR description LIKE ? OR make LIKE ? OR car_model LIKE ?)");
    const q = `%${filter.q}%`;
    params.push(q, q, q, q);
  }
  if (filter.city) {
    where.push("city LIKE ?");
    params.push(`%${filter.city}%`);
  }
  if (filter.make) {
    where.push("make LIKE ?");
    params.push(`%${filter.make}%`);
  }
  if (filter.model) {
    where.push("car_model LIKE ?");
    params.push(`%${filter.model}%`);
  }
  if (filter.minPrice !== undefined) {
    where.push("price >= ?");
    params.push(filter.minPrice);
  }
  if (filter.maxPrice !== undefined) {
    where.push("price <= ?");
    params.push(filter.maxPrice);
  }
  const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";
  const total = (getDb().prepare(`SELECT COUNT(*) AS c FROM ads ${whereSql}`).get(...params) as { c: number }).c;
  const items = getDb()
    .prepare(`SELECT * FROM ads ${whereSql} ORDER BY featured DESC, created_at DESC LIMIT ? OFFSET ?`)
    .all(...params, filter.limit, filter.offset) as AdRow[];
  return { items, total };
}

export function getAdById(id: string): AdRow | undefined {
  return getDb().prepare("SELECT * FROM ads WHERE id = ?").get(id) as AdRow | undefined;
}

export function createAd(input: Record<string, unknown>, ownerId: string): AdRow {
  const row: AdRow = {
    id: uid("AD"),
    title: String(input.title).trim(),
    description: String(input.description).trim(),
    make: String(input.make).trim(),
    car_model: String(input.model).trim(),
    year: Number(input.year),
    price: Number(input.price),
    mileage: Number(input.mileage),
    fuel: String(input.fuel || "بنزين"),
    transmission: String(input.transmission || "أوتوماتيك"),
    color: String(input.color || ""),
    city: String(input.city || "مسقط"),
    images: JSON.stringify(Array.isArray(input.images) ? input.images : []),
    video_url: String(input.videoUrl || ""),
    status: String(input.status || "active"),
    featured: input.featured ? 1 : 0,
    owner_id: ownerId,
    created_at: nowIso(),
  };
  getDb()
    .prepare(
      `INSERT INTO ads (id,title,description,make,car_model,year,price,mileage,fuel,transmission,color,city,images,video_url,status,featured,owner_id,created_at)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
    )
    .run(
      row.id,
      row.title,
      row.description,
      row.make,
      row.car_model,
      row.year,
      row.price,
      row.mileage,
      row.fuel,
      row.transmission,
      row.color,
      row.city,
      row.images,
      row.video_url,
      row.status,
      row.featured,
      row.owner_id,
      row.created_at,
    );
  return row;
}

export function updateAd(id: string, body: Record<string, unknown>): AdRow | undefined {
  const ad = getAdById(id);
  if (!ad) return undefined;
  const next = { ...ad };
  const map: Record<string, keyof AdRow> = {
    title: "title",
    description: "description",
    make: "make",
    year: "year",
    price: "price",
    mileage: "mileage",
    fuel: "fuel",
    transmission: "transmission",
    color: "color",
    city: "city",
    videoUrl: "video_url",
    status: "status",
  };
  for (const [k, col] of Object.entries(map)) {
    if (body[k] !== undefined) (next as Record<string, unknown>)[col] = body[k];
  }
  if (body.model !== undefined) next.car_model = String(body.model);
  if (body.images !== undefined) next.images = JSON.stringify(body.images);
  if (body.featured !== undefined) next.featured = body.featured ? 1 : 0;
  getDb()
    .prepare(
      `UPDATE ads SET title=?,description=?,make=?,car_model=?,year=?,price=?,mileage=?,fuel=?,transmission=?,color=?,city=?,images=?,video_url=?,status=?,featured=? WHERE id=?`,
    )
    .run(
      next.title,
      next.description,
      next.make,
      next.car_model,
      next.year,
      next.price,
      next.mileage,
      next.fuel,
      next.transmission,
      next.color,
      next.city,
      next.images,
      next.video_url,
      next.status,
      next.featured,
      id,
    );
  return getAdById(id);
}

export function deleteAd(id: string): boolean {
  getDb().prepare("DELETE FROM ad_likes WHERE ad_id = ?").run(id);
  const res = getDb().prepare("DELETE FROM ads WHERE id = ?").run(id);
  return res.changes > 0;
}

export function toggleLike(adId: string, userId: string): void {
  const existing = getDb()
    .prepare("SELECT 1 FROM ad_likes WHERE ad_id = ? AND user_id = ?")
    .get(adId, userId);
  if (existing) getDb().prepare("DELETE FROM ad_likes WHERE ad_id = ? AND user_id = ?").run(adId, userId);
  else getDb().prepare("INSERT INTO ad_likes (ad_id,user_id) VALUES (?,?)").run(adId, userId);
}

export function likeCount(adId: string): number {
  return (getDb().prepare("SELECT COUNT(*) AS c FROM ad_likes WHERE ad_id = ?").get(adId) as { c: number }).c;
}

export function userLiked(adId: string, userId?: string): boolean {
  if (!userId) return false;
  return Boolean(getDb().prepare("SELECT 1 FROM ad_likes WHERE ad_id = ? AND user_id = ?").get(adId, userId));
}

export function listMyAds(ownerId: string): AdRow[] {
  return getDb().prepare("SELECT * FROM ads WHERE owner_id = ? ORDER BY created_at DESC").all(ownerId) as AdRow[];
}

export function seedDemoAds(): void {
  const count = (getDb().prepare("SELECT COUNT(*) AS c FROM ads").get() as { c: number }).c;
  if (count > 0) return;
  const admin = findUserByEmail((process.env.DEMO_ADMIN_EMAIL || "admin@najjar.om").toLowerCase());
  if (!admin) return;
  const samples = [
    { title: "تويota كامري 2022", description: "صيانة الوكالة", make: "Toyota", model: "Camry", year: 2022, price: 7800, mileage: 42000, city: "مسقط", featured: true },
    { title: "نيسان باترول 2020", description: "فل كامل", make: "Nissan", model: "Patrol", year: 2020, price: 14500, mileage: 88000, city: "صلالة", featured: false },
    { title: "هيونداي توسان 2023", description: "ضمان ساري", make: "Hyundai", model: "Tucson", year: 2023, price: 9200, mileage: 18000, city: "صحار", featured: true },
  ];
  for (const s of samples) createAd(s, admin.id);
}
