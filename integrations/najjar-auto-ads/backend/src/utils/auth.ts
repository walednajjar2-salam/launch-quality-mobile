import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { Request, Response, NextFunction } from "express";

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 16) {
    throw new Error("JWT_SECRET must be at least 16 characters");
  }
  return secret;
}

export function validateEmail(email: string): boolean {
  return EMAIL_RE.test(email.trim());
}

export function validatePassword(password: string): string | null {
  if (!password || password.length < 8) {
    return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
  }
  if (!/[A-Za-z]/.test(password) || !/\d/.test(password)) {
    return "كلمة المرور يجب أن تحتوي حروفاً وأرقاماً";
  }
  return null;
}

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, 12);
}

export async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

export function signToken(userId: string, role: string): string {
  return jwt.sign({ sub: userId, role }, getJwtSecret(), { expiresIn: "7d" });
}

export interface AuthRequest extends Request {
  userId?: string;
  userRole?: string;
}

export function authMiddleware(req: AuthRequest, res: Response, next: NextFunction): void {
  const header = req.headers.authorization || "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : "";
  if (!token) {
    res.status(401).json({ ok: false, error: "Authentication required" });
    return;
  }
  try {
    const payload = jwt.verify(token, getJwtSecret()) as { sub: string; role: string };
    req.userId = payload.sub;
    req.userRole = payload.role;
    next();
  } catch {
    res.status(401).json({ ok: false, error: "Invalid or expired token" });
  }
}

export function publicUser(user: { _id: unknown; name: string; email: string; phone?: string; role: string; rating: number; createdAt: Date }) {
  return {
    id: String(user._id),
    name: user.name,
    email: user.email,
    phone: user.phone || "",
    role: user.role,
    rating: user.rating,
    createdAt: user.createdAt,
  };
}
