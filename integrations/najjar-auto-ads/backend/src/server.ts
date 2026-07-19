import "dotenv/config";
import { createApp } from "./app.js";
import { connectDb } from "./db.js";
import { seedDemoAds } from "./controllers/adsController.js";
import { User } from "./models/index.js";
import { hashPassword } from "./utils/auth.js";

const PORT = parseInt(process.env.PORT || "4000", 10);
const MONGODB_URI =
  process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/najjar_auto_ads";

async function ensureDemoUser() {
  const email = (process.env.DEMO_ADMIN_EMAIL || "admin@najjar.om").toLowerCase();
  const exists = await User.findOne({ email });
  if (exists) return;
  await User.create({
    name: "وليد نجار",
    email,
    passwordHash: await hashPassword(process.env.DEMO_ADMIN_PASSWORD || "Najjar2026!"),
    phone: "+96871924089",
    role: "admin",
    rating: 5,
  });
  console.log(`Demo admin created: ${email}`);
}

async function main() {
  await connectDb(MONGODB_URI);
  await ensureDemoUser();
  await seedDemoAds();
  const app = createApp();
  app.listen(PORT, () => {
    console.log(`NAJJAR Auto Ads API on :${PORT}`);
  });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
