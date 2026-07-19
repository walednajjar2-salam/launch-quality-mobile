import { Response } from "express";
import {
  createUser,
  findUserByEmail,
  findUserById,
} from "../store/index.js";
import {
  AuthRequest,
  hashPassword,
  publicUser,
  signToken,
  validateEmail,
  validatePassword,
  verifyPassword,
} from "../utils/auth.js";

export async function register(req: AuthRequest, res: Response): Promise<void> {
  const { name, email, password, phone } = req.body || {};
  if (!name?.trim() || !email?.trim() || !password) {
    res.status(400).json({ ok: false, error: "الاسم والبريد وكلمة المرور مطلوبة" });
    return;
  }
  if (!validateEmail(email)) {
    res.status(400).json({ ok: false, error: "البريد الإلكتروني غير صالح" });
    return;
  }
  const pwdErr = validatePassword(password);
  if (pwdErr) {
    res.status(400).json({ ok: false, error: pwdErr });
    return;
  }
  if (await findUserByEmail(email)) {
    res.status(409).json({ ok: false, error: "البريد مسجل مسبقاً" });
    return;
  }
  const user = await createUser({
    name: name.trim(),
    email: email.trim(),
    passwordHash: hashPassword(password),
    phone: phone?.trim() || "",
    role: "user",
  });
  const token = signToken(user.id, user.role);
  res.status(201).json({ ok: true, token, user: publicUser(user) });
}

export async function login(req: AuthRequest, res: Response): Promise<void> {
  const { email, password } = req.body || {};
  if (!email?.trim() || !password) {
    res.status(400).json({ ok: false, error: "البريد وكلمة المرور مطلوبة" });
    return;
  }
  const user = await findUserByEmail(email);
  if (!user || !verifyPassword(password, user.password_hash)) {
    res.status(401).json({ ok: false, error: "بيانات الدخول غير صحيحة" });
    return;
  }
  const token = signToken(user.id, user.role);
  res.json({ ok: true, token, user: publicUser(user) });
}

export async function me(req: AuthRequest, res: Response): Promise<void> {
  const user = await findUserById(req.userId!);
  if (!user) {
    res.status(404).json({ ok: false, error: "المستخدم غير موجود" });
    return;
  }
  res.json({ ok: true, user: publicUser(user) });
}
