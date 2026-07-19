import cors from "cors";
import express from "express";
import rateLimit from "express-rate-limit";
import helmet from "helmet";
import morgan from "morgan";
import adsRoutes from "./routes/ads.js";
import authRoutes from "./routes/auth.js";

export function createApp() {
  const app = express();
  app.set("trust proxy", 1);
  app.use(helmet());
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

  app.use((_req, res) => {
    res.status(404).json({ ok: false, error: "Not found" });
  });

  app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
    console.error(err);
    res.status(500).json({ ok: false, error: "Internal server error" });
  });

  return app;
}
