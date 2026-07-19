import { Router } from "express";
import {
  createAdHandler,
  deleteAdHandler,
  getAd,
  likeAd,
  listAdsHandler,
  myAds,
  updateAdHandler,
} from "../controllers/adsController.js";
import { authMiddleware } from "../utils/auth.js";

const router = Router();

router.get("/", listAdsHandler);
router.get("/mine", authMiddleware, myAds);
router.get("/:id", getAd);
router.post("/", authMiddleware, createAdHandler);
router.put("/:id", authMiddleware, updateAdHandler);
router.delete("/:id", authMiddleware, deleteAdHandler);
router.post("/:id/like", authMiddleware, likeAd);

export default router;
