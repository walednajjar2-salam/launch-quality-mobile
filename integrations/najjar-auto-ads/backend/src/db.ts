import Database from "better-sqlite3";
import fs from "fs";
import path from "path";

const DATA_DIR = process.env.NAJJAR_DATA_DIR || path.join(process.cwd(), "data");
const DB_PATH = path.join(DATA_DIR, "najjar.sqlite3");

export type UserRow = {
  id: string;
  name: string;
  email: string;
  password_hash: string;
  phone: string;
  role: string;
  rating: number;
  created_at: string;
};

export type AdRow = {
  id: string;
  title: string;
  description: string;
  make: string;
  car_model: string;
  year: number;
  price: number;
  mileage: number;
  fuel: string;
  transmission: string;
  color: string;
  city: string;
  images: string;
  video_url: string;
  status: string;
  featured: number;
  owner_id: string;
  created_at: string;
};

let db: Database.Database;

export function getDb(): Database.Database {
  if (!db) throw new Error("Database not initialized");
  return db;
}

export function initDb(): Database.Database {
  fs.mkdirSync(DATA_DIR, { recursive: true });
  db = new Database(DB_PATH);
  db.pragma("journal_mode = WAL");
  db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      phone TEXT DEFAULT '',
      role TEXT DEFAULT 'user',
      rating REAL DEFAULT 0,
      created_at TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS ads (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      make TEXT NOT NULL,
      car_model TEXT NOT NULL,
      year INTEGER NOT NULL,
      price REAL NOT NULL,
      mileage INTEGER NOT NULL,
      fuel TEXT DEFAULT 'بنزين',
      transmission TEXT DEFAULT 'أوتوماتيك',
      color TEXT DEFAULT '',
      city TEXT DEFAULT 'مسقط',
      images TEXT DEFAULT '[]',
      video_url TEXT DEFAULT '',
      status TEXT DEFAULT 'active',
      featured INTEGER DEFAULT 0,
      owner_id TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY(owner_id) REFERENCES users(id)
    );
    CREATE TABLE IF NOT EXISTS ad_likes (
      ad_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      PRIMARY KEY(ad_id, user_id)
    );
  `);
  return db;
}

export function uid(prefix: string): string {
  return `${prefix}-${Math.random().toString(16).slice(2, 10).toUpperCase()}`;
}

export function nowIso(): string {
  return new Date().toISOString().replace("T", " ").slice(0, 19);
}
