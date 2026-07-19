import { initDb, type AdRow, type UserRow } from "../db.js";
import { hashPassword } from "../utils/auth.js";
import { connectMongo } from "../models/mongo.js";
import * as mongo from "./mongo.js";
import * as sqlite from "./sqlite.js";

let engine: "mongo" | "sqlite" = "sqlite";

export function getEngine(): string {
  return engine;
}

export async function initStore(): Promise<void> {
  const uri = (process.env.MONGODB_URI || process.env.MONGO_URL || "").trim();
  if (uri) {
    await connectMongo(uri);
    engine = "mongo";
    console.log("[NAJJAR] Database engine: MongoDB");
    return;
  }
  initDb();
  engine = "sqlite";
  console.log("[NAJJAR] Database engine: SQLite");
}

export async function findUserByEmail(email: string): Promise<UserRow | undefined> {
  return engine === "mongo" ? mongo.mongoFindUserByEmail(email) : sqlite.findUserByEmail(email);
}

export async function findUserById(id: string): Promise<UserRow | undefined> {
  return engine === "mongo" ? mongo.mongoFindUserById(id) : sqlite.findUserById(id);
}

export async function createUser(input: {
  name: string;
  email: string;
  passwordHash: string;
  phone?: string;
  role?: string;
}): Promise<UserRow> {
  return engine === "mongo" ? mongo.mongoCreateUser(input) : sqlite.createUser(input);
}

export async function ensureDemoUser(): Promise<void> {
  const email = (process.env.DEMO_ADMIN_EMAIL || "admin@najjar.om").toLowerCase();
  if (await findUserByEmail(email)) return;
  await createUser({
    name: "وليد نجار",
    email,
    passwordHash: hashPassword(process.env.DEMO_ADMIN_PASSWORD || "Najjar2026!"),
    phone: "+96871924089",
    role: "admin",
  });
}

export async function listAds(filter: Parameters<typeof sqlite.listAds>[0]) {
  return engine === "mongo" ? mongo.mongoListAds(filter) : sqlite.listAds(filter);
}

export async function getAdById(id: string) {
  return engine === "mongo" ? mongo.mongoGetAdById(id) : sqlite.getAdById(id);
}

export async function createAd(input: Record<string, unknown>, ownerId: string) {
  return engine === "mongo" ? mongo.mongoCreateAd(input, ownerId) : sqlite.createAd(input, ownerId);
}

export async function updateAd(id: string, body: Record<string, unknown>) {
  return engine === "mongo" ? mongo.mongoUpdateAd(id, body) : sqlite.updateAd(id, body);
}

export async function deleteAd(id: string) {
  return engine === "mongo" ? mongo.mongoDeleteAd(id) : sqlite.deleteAd(id);
}

export async function toggleLike(adId: string, userId: string) {
  return engine === "mongo" ? mongo.mongoToggleLike(adId, userId) : sqlite.toggleLike(adId, userId);
}

export async function likeCount(adId: string) {
  return engine === "mongo" ? mongo.mongoLikeCount(adId) : sqlite.likeCount(adId);
}

export async function userLiked(adId: string, userId?: string) {
  return engine === "mongo" ? mongo.mongoUserLiked(adId, userId) : sqlite.userLiked(adId, userId);
}

export async function listMyAds(ownerId: string) {
  return engine === "mongo" ? mongo.mongoListMyAds(ownerId) : sqlite.listMyAds(ownerId);
}

export async function seedDemoAds(): Promise<void> {
  const email = (process.env.DEMO_ADMIN_EMAIL || "admin@najjar.om").toLowerCase();
  if (engine === "mongo") return mongo.mongoSeedDemoAds(email);
  return sqlite.seedDemoAds();
}

export type { AdRow, UserRow };
