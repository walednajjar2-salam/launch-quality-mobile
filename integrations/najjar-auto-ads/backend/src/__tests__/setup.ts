import fs from "fs";
import path from "path";
import { initDb } from "../db.js";

const TEST_DB = path.join(process.cwd(), "data", "test-najjar.sqlite3");

beforeAll(() => {
  process.env.JWT_SECRET = "test-secret-key-min-16-chars";
  fs.mkdirSync(path.dirname(TEST_DB), { recursive: true });
  if (fs.existsSync(TEST_DB)) fs.unlinkSync(TEST_DB);
  process.env.NAJJAR_DATA_DIR = path.dirname(TEST_DB);
  initDb();
});

afterAll(() => {
  if (fs.existsSync(TEST_DB)) fs.unlinkSync(TEST_DB);
});

beforeEach(() => {
  const db = initDb();
  db.exec("DELETE FROM ad_likes; DELETE FROM ads; DELETE FROM users;");
});
