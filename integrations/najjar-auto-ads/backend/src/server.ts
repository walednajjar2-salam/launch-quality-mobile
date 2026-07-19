import "dotenv/config";
import { createApp } from "./app.js";
import { ensureDemoUser, initStore, seedDemoAds } from "./store/index.js";

const PORT = parseInt(process.env.PORT || "4000", 10);

async function main() {
  await initStore();
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
