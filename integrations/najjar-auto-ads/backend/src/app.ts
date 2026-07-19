import cors from "cors";
import express from "express";
import rateLimit from "express-rate-limit";
import fs from "fs";
import helmet from "helmet";
import morgan from "morgan";
import path from "path";
import { fileURLToPath } from "url";
import adsRoutes from "./routes/ads.js";
import authRoutes from "./routes/auth.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const publicDir = path.join(__dirname, "..", "public");

export function createApp() {
  const app = express();
  app.set("trust proxy", 1);
  app.use(
    helmet({
      contentSecurityPolicy: process.env.NODE_ENV === "production" ? false : undefined,
    }),
  );
  app.use(
    cors({
      origin: process.env.CORS_ORIGIN?.split(",").map((s) => s.trim()) || true,
      credentials: true,
    }),
  );
  app.use(express.json({ limit: "2mb" }));
  app.use(morgan(process.env.NODE_ENV === "production" ? "combined" : "dev"));
  app.use(
    rateLimit({
      windowMs: 15 * 60 * 1000,
      max: 300,
      standardHeaders: true,
      legacyHeaders: false,
    }),
  );

  app.get("/api/health", (_req, res) => {
    res.json({
      ok: true,
      service: "najjar-auto-ads-api",
      version: "1.0.0",
    });
  });

  app.use("/api/auth", authRoutes);
  app.use("/api/ads", adsRoutes);

  if (fs.existsSync(publicDir)) {
    app.use(express.static(publicDir));
    app.get("*", (req, res, next) => {
      if (req.path.startsWith("/api")) return next();
      res.sendFile(path.join(publicDir, "index.html"), (err) => {
        if (err) next();
      });
    });
  }

  app.use((_req, res) => {
    res.status(404).json({ ok: false, error: "Not found" });
  });

  app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
    console.error(err);
    res.status(500).json({ ok: false, error: "Internal server error" });
  });

  return app;
}
