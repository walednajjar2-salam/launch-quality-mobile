import { Router } from "express";
import {
  createAd,
  deleteAd,
  getAd,
  likeAd,
  listAds,
  myAds,
  updateAd,
} from "../controllers/adsController.js";
import { authMiddleware, AuthRequest } from "../utils/auth.js";

const router = Router();

router.get("/", listAds);
router.get("/mine", authMiddleware, myAds);
router.get("/:id", getAd);
router.post("/", authMiddleware, createAd);
router.put("/:id", authMiddleware, updateAd);
router.delete("/:id", authMiddleware, deleteAd);
router.post("/:id/like", authMiddleware, likeAd);

export default router;
