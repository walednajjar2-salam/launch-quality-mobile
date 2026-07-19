import "dotenv/config";
import { createApp } from "./app.js";
import { initDb } from "./db.js";
import { ensureDemoUser, seedDemoAds } from "./store/index.js";

const PORT = parseInt(process.env.PORT || "4000", 10);

initDb();
ensureDemoUser();
seedDemoAds();

const app = createApp();
app.listen(PORT, () => {
  console.log(`NAJJAR Auto Ads API on :${PORT}`);
});
