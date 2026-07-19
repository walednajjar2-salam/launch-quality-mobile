import { hashPassword } from "../utils/auth.js";
import { nowIso, uid } from "../db.js";
import {
  AdModel,
  connectMongo,
  toAdRow,
  toUserRow,
  UserModel,
  type IAdDoc,
} from "../models/mongo.js";
import type { AdRow, UserRow } from "../db.js";

export async function mongoFindUserByEmail(email: string): Promise<UserRow | undefined> {
  const doc = await UserModel.findOne({ email: email.toLowerCase() }).lean();
  return doc ? toUserRow(doc) : undefined;
}

export async function mongoFindUserById(id: string): Promise<UserRow | undefined> {
  const doc = await UserModel.findOne({ id }).lean();
  return doc ? toUserRow(doc) : undefined;
}

export async function mongoCreateUser(input: {
  name: string;
  email: string;
  passwordHash: string;
  phone?: string;
  role?: string;
}): Promise<UserRow> {
  const doc = await UserModel.create({
    id: uid("USR"),
    name: input.name,
    email: input.email.toLowerCase(),
    passwordHash: input.passwordHash,
    phone: input.phone || "",
    role: input.role || "user",
    rating: 5,
    createdAt: nowIso(),
  });
  return toUserRow(doc.toObject());
}

export async function mongoListAds(filter: {
  q?: string;
  city?: string;
  make?: string;
  model?: string;
  minPrice?: number;
  maxPrice?: number;
  limit: number;
  offset: number;
}): Promise<{ items: AdRow[]; total: number }> {
  const query: Record<string, unknown> = { status: "active" };
  if (filter.city) query.city = new RegExp(filter.city, "i");
  if (filter.make) query.make = new RegExp(filter.make, "i");
  if (filter.model) query.carModel = new RegExp(filter.model, "i");
  if (filter.minPrice !== undefined || filter.maxPrice !== undefined) {
    query.price = {};
    if (filter.minPrice !== undefined) (query.price as Record<string, number>).$gte = filter.minPrice;
    if (filter.maxPrice !== undefined) (query.price as Record<string, number>).$lte = filter.maxPrice;
  }
  if (filter.q) {
    const q = new RegExp(filter.q, "i");
    query.$or = [{ title: q }, { description: q }, { make: q }, { carModel: q }];
  }
  const total = await AdModel.countDocuments(query);
  const docs = await AdModel.find(query)
    .sort({ featured: -1, createdAt: -1 })
    .skip(filter.offset)
    .limit(filter.limit)
    .lean();
  return { items: docs.map(toAdRow), total };
}

export async function mongoGetAdById(id: string): Promise<AdRow | undefined> {
  const doc = await AdModel.findOne({ id }).lean();
  return doc ? toAdRow(doc) : undefined;
}

export async function mongoCreateAd(input: Record<string, unknown>, ownerId: string): Promise<AdRow> {
  const doc = await AdModel.create({
    id: uid("AD"),
    title: String(input.title).trim(),
    description: String(input.description).trim(),
    make: String(input.make).trim(),
    carModel: String(input.model).trim(),
    year: Number(input.year),
    price: Number(input.price),
    mileage: Number(input.mileage),
    fuel: String(input.fuel || "بنزين"),
    transmission: String(input.transmission || "أوتوماتيك"),
    color: String(input.color || ""),
    city: String(input.city || "مسقط"),
    images: Array.isArray(input.images) ? input.images.map(String) : [],
    videoUrl: String(input.videoUrl || ""),
    status: String(input.status || "active"),
    featured: Boolean(input.featured),
    ownerId,
    likes: [],
    createdAt: nowIso(),
  });
  return toAdRow(doc.toObject());
}

export async function mongoUpdateAd(id: string, body: Record<string, unknown>): Promise<AdRow | undefined> {
  const doc = await AdModel.findOne({ id });
  if (!doc) return undefined;
  const fields: (keyof IAdDoc)[] = [
    "title",
    "description",
    "make",
    "year",
    "price",
    "mileage",
    "fuel",
    "transmission",
    "color",
    "city",
    "status",
  ];
  for (const field of fields) {
    if (body[field] !== undefined) (doc as unknown as Record<string, unknown>)[field] = body[field];
  }
  if (body.model !== undefined) doc.carModel = String(body.model);
  if (body.images !== undefined) doc.images = Array.isArray(body.images) ? body.images.map(String) : [];
  if (body.videoUrl !== undefined) doc.videoUrl = String(body.videoUrl);
  if (body.featured !== undefined) doc.featured = Boolean(body.featured);
  await doc.save();
  return toAdRow(doc.toObject());
}

export async function mongoDeleteAd(id: string): Promise<boolean> {
  const res = await AdModel.deleteOne({ id });
  return res.deletedCount > 0;
}

export async function mongoToggleLike(adId: string, userId: string): Promise<void> {
  const doc = await AdModel.findOne({ id: adId });
  if (!doc) return;
  const idx = doc.likes.indexOf(userId);
  if (idx >= 0) doc.likes.splice(idx, 1);
  else doc.likes.push(userId);
  await doc.save();
}

export async function mongoLikeCount(adId: string): Promise<number> {
  const doc = await AdModel.findOne({ id: adId }).select("likes").lean();
  return doc?.likes?.length || 0;
}

export async function mongoUserLiked(adId: string, userId?: string): Promise<boolean> {
  if (!userId) return false;
  const doc = await AdModel.findOne({ id: adId }).select("likes").lean();
  return Boolean(doc?.likes?.includes(userId));
}

export async function mongoListMyAds(ownerId: string): Promise<AdRow[]> {
  const docs = await AdModel.find({ ownerId }).sort({ createdAt: -1 }).lean();
  return docs.map(toAdRow);
}

export async function mongoSeedDemoAds(adminEmail: string): Promise<void> {
  const count = await AdModel.countDocuments();
  if (count > 0) return;
  const admin = await mongoFindUserByEmail(adminEmail);
  if (!admin) return;
  const samples = [
    { title: "تويota كامري 2022", description: "صيانة الوكالة", make: "Toyota", model: "Camry", year: 2022, price: 7800, mileage: 42000, city: "مسقط", featured: true },
    { title: "نيسان باترول 2020", description: "فل كامل", make: "Nissan", model: "Patrol", year: 2020, price: 14500, mileage: 88000, city: "صلالة", featured: false },
    { title: "هيونداي توسان 2023", description: "ضمان ساري", make: "Hyundai", model: "Tucson", year: 2023, price: 9200, mileage: 18000, city: "صحار", featured: true },
  ];
  for (const s of samples) await mongoCreateAd(s, admin.id);
}
