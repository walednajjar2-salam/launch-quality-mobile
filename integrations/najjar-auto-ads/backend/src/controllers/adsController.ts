import { Response } from "express";
import type { AdRow } from "../db.js";
import {
  createAd,
  deleteAd,
  getAdById,
  likeCount,
  listAds,
  listMyAds,
  toggleLike,
  updateAd,
  userLiked,
} from "../store/index.js";
import { AuthRequest } from "../utils/auth.js";

async function serializeAd(ad: AdRow, userId?: string) {
  return {
    id: ad.id,
    title: ad.title,
    description: ad.description,
    make: ad.make,
    model: ad.car_model,
    year: ad.year,
    price: ad.price,
    mileage: ad.mileage,
    fuel: ad.fuel,
    transmission: ad.transmission,
    color: ad.color,
    city: ad.city,
    images: JSON.parse(ad.images || "[]"),
    videoUrl: ad.video_url || "",
    status: ad.status,
    featured: Boolean(ad.featured),
    likesCount: await likeCount(ad.id),
    liked: await userLiked(ad.id, userId),
    ownerId: ad.owner_id,
    createdAt: ad.created_at,
  };
}

export async function listAdsHandler(req: AuthRequest, res: Response): Promise<void> {
  const page = Math.max(1, parseInt(String(req.query.page || "1"), 10) || 1);
  const limit = Math.min(50, Math.max(1, parseInt(String(req.query.limit || "12"), 10) || 12));
  const { items, total } = await listAds({
    q: req.query.q ? String(req.query.q) : undefined,
    city: req.query.city ? String(req.query.city) : undefined,
    make: req.query.make ? String(req.query.make) : undefined,
    model: req.query.model ? String(req.query.model) : undefined,
    minPrice: req.query.minPrice ? Number(req.query.minPrice) : undefined,
    maxPrice: req.query.maxPrice ? Number(req.query.maxPrice) : undefined,
    limit,
    offset: (page - 1) * limit,
  });
  const serialized = await Promise.all(items.map((ad) => serializeAd(ad, req.userId)));
  res.json({
    ok: true,
    items: serialized,
    page,
    limit,
    total,
    pages: Math.ceil(total / limit),
  });
}

export async function getAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await getAdById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  res.json({ ok: true, item: await serializeAd(ad, req.userId) });
}

export async function createAdHandler(req: AuthRequest, res: Response): Promise<void> {
  const body = req.body || {};
  const required = ["title", "description", "make", "model", "year", "price", "mileage"];
  for (const key of required) {
    if (body[key] === undefined || body[key] === "") {
      res.status(400).json({ ok: false, error: `الحقل ${key} مطلوب` });
      return;
    }
  }
  const ad = await createAd(body, req.userId!);
  res.status(201).json({ ok: true, item: await serializeAd(ad, req.userId) });
}

export async function updateAdHandler(req: AuthRequest, res: Response): Promise<void> {
  const ad = await getAdById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  if (ad.owner_id !== req.userId && req.userRole !== "admin") {
    res.status(403).json({ ok: false, error: "غير مصرح" });
    return;
  }
  const updated = await updateAd(req.params.id, req.body || {});
  res.json({ ok: true, item: await serializeAd(updated!, req.userId) });
}

export async function deleteAdHandler(req: AuthRequest, res: Response): Promise<void> {
  const ad = await getAdById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  if (ad.owner_id !== req.userId && req.userRole !== "admin") {
    res.status(403).json({ ok: false, error: "غير مصرح" });
    return;
  }
  await deleteAd(req.params.id);
  res.json({ ok: true });
}

export async function likeAd(req: AuthRequest, res: Response): Promise<void> {
  const ad = await getAdById(req.params.id);
  if (!ad) {
    res.status(404).json({ ok: false, error: "الإعلان غير موجود" });
    return;
  }
  await toggleLike(req.params.id, req.userId!);
  const fresh = await getAdById(req.params.id);
  res.json({ ok: true, item: await serializeAd(fresh!, req.userId) });
}

export async function myAds(req: AuthRequest, res: Response): Promise<void> {
  const items = await listMyAds(req.userId!);
  const serialized = await Promise.all(items.map((ad) => serializeAd(ad, req.userId)));
  res.json({ ok: true, items: serialized });
}
