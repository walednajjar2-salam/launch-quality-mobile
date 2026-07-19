import { Response } from "express";
import { Types } from "mongoose";
import { Ad, User } from "../models/index.js";
import { AuthRequest } from "../utils/auth.js";

function serializeAd(ad: InstanceType<typeof Ad>, userId?: string) {
  return {
    id: String(ad._id),
    title: ad.title,
    description: ad.description,
    make: ad.make,
    carModel: ad.carModel,
    year: ad.year,
    price: ad.price,
    mileage: ad.mileage,
    fuel: ad.fuel,
    transmission: ad.transmission,
    color: ad.color,
    city: ad.city,
    images: ad.images,
    videoUrl: ad.videoUrl || "",
    status: ad.status,
    featured: ad.featured,
    likesCount: ad.likes.length,
    liked: userId ? ad.likes.some((id) => String(id) === userId) : false,
    ownerId: String(ad.owner),
    createdAt: ad.createdAt,
  };
}

export async function listAds(req: AuthRequest, res: Response): Promise<void> {
  const page = Math.max(1, parseInt(String(req.query.page || "1"), 10) || 1);
  const limit = Math.min(50, Math.max(1, parseInt(String(req.query.limit || "12"), 10) || 12));
  const filter: Record<string, unknown> = { status: "active" };
  if (req.query.make) filter.make = new RegExp(String(req.query.make), "i");
  if (req.query.model) filter.carModel = new RegExp(String(req.query.model), "i");
  if (req.query.city) filter.city = new RegExp(String(req.query.city), "i");
  if (req.query.minPrice) filter.price = { ...(filter.price as object), $gte: Number(req.query.minPrice) };
  if (req.query.maxPrice) {
    filter.price = { ...(filter.price as object), $lte: Number(req.query.maxPrice) };
  }
  if (req.query.q) {
    const q = String(req.query.q);
    filter.$or = [
      { title: new RegExp(q, "i") },
      { description: new RegExp(q, "i") },
      { make: new RegExp(q, "i") },
      { carModel: new RegExp(q, "i") },
    ];
  }
  const total = await Ad.countDocuments(filter);
  const items = await Ad.find(filter)
    .sort({ featured: -1, createdAt: -1 })
    .skip((page - 1) * limit)
    .limit(limit);
  res.json({
    ok: true,
    items: items.map((ad) => serializeAd(ad, req.userId)),
    page,
    limit,
    total,
    pages: Math.ceil(total / limit),
  });
}

export async function getAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await Ad.findById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  res.json({ ok: true, item: serializeAd(ad, req.userId) });
}

export async function createAd(req: AuthRequest, res: Response): Promise<void> {
  const body = req.body || {};
  const required = ["title", "description", "make", "model", "year", "price", "mileage"];
  for (const key of required) {
    if (body[key] === undefined || body[key] === "") {
      res.status(400).json({ ok: false, error: `الحقل ${key} مطلوب` });
      return;
    }
  }
  const ad = await Ad.create({
    title: String(body.title).trim(),
    description: String(body.description).trim(),
    make: String(body.make).trim(),
    carModel: String(body.model).trim(),
    year: Number(body.year),
    price: Number(body.price),
    mileage: Number(body.mileage),
    fuel: body.fuel || "بنزين",
    transmission: body.transmission || "أوتوماتيك",
    color: body.color || "",
    city: body.city || "مسقط",
    images: Array.isArray(body.images) ? body.images : [],
    videoUrl: body.videoUrl || "",
    status: body.status || "active",
    featured: Boolean(body.featured),
    owner: new Types.ObjectId(req.userId),
  });
  res.status(201).json({ ok: true, item: serializeAd(ad, req.userId) });
}

export async function updateAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await Ad.findById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  if (String(ad.owner) !== req.userId && req.userRole !== "admin") {
    res.status(403).json({ ok: false, error: "غير مصرح" });
    return;
  }
  const fields = [
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
    "images",
    "videoUrl",
    "status",
    "featured",
  ] as const;
  for (const field of fields) {
    if (req.body?.[field] !== undefined) {
      (ad as unknown as Record<string, unknown>)[field] = req.body[field];
    }
  }
  if (req.body?.model !== undefined) {
    ad.carModel = String(req.body.model);
  }
  await ad.save();
  res.json({ ok: true, item: serializeAd(ad, req.userId) });
}

export async function deleteAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await Ad.findById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  if (String(ad.owner) !== req.userId && req.userRole !== "admin") {
    res.status(403).json({ ok: false, error: "غير مصرح" });
    return;
  }
  await ad.deleteOne();
  res.json({ ok: true });
}

export async function likeAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await Ad.findById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  const uid = new Types.ObjectId(req.userId);
  const idx = ad.likes.findIndex((id) => String(id) === req.userId);
  if (idx >= 0) ad.likes.splice(idx, 1);
  else ad.likes.push(uid);
  await ad.save();
  res.json({ ok: true, item: serializeAd(ad, req.userId) });
}

export async function myAds(req: AuthRequest, res: Response): Promise<void> {
  const items = await Ad.find({ owner: req.userId }).sort({ createdAt: -1 });
  res.json({ ok: true, items: items.map((ad) => serializeAd(ad, req.userId)) });
}

export async function seedDemoAds(): Promise<void> {
  const count = await Ad.countDocuments();
  if (count > 0) return;
  const admin = await User.findOne();
  if (!admin) return;
  const samples = [
    {
      title: "تويota كامري 2022 — حالة ممتازة",
      description: "سيارة واحدة، صيانة الوكالة، فحص شامل.",
      make: "Toyota",
      carModel: "Camry",
      year: 2022,
      price: 7800,
      mileage: 42000,
      city: "مسقط",
      featured: true,
    },
    {
      title: "نيسان باترول 2020",
      description: "فل كامل، 8 سلندر، جاهزة للاستخدام.",
      make: "Nissan",
      carModel: "Patrol",
      year: 2020,
      price: 14500,
      mileage: 88000,
      city: "صلالة",
      featured: false,
    },
    {
      title: "هيونداي توسان 2023",
      description: "ضمان ساري، لون أبيض، داخل جلد.",
      make: "Hyundai",
      carModel: "Tucson",
      year: 2023,
      price: 9200,
      mileage: 18000,
      city: "صحار",
      featured: true,
    },
  ];
  for (const sample of samples) {
    await Ad.create({ ...sample, owner: admin._id, images: [], status: "active" });
  }
}
