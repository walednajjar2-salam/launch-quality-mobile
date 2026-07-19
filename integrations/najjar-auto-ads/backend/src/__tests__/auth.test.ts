import request from "supertest";
import { createApp } from "../app.js";
import { validateEmail, validatePassword } from "../utils/auth.js";

describe("auth validation", () => {
  it("validates email", () => {
    expect(validateEmail("a@b.com")).toBe(true);
    expect(validateEmail("bad")).toBe(false);
  });

  it("validates password strength", () => {
    expect(validatePassword("short")).not.toBeNull();
    expect(validatePassword("ValidPass1")).toBeNull();
  });
});

describe("auth routes", () => {
  const app = createApp();

  it("registers and logs in", async () => {
    const reg = await request(app)
      .post("/api/auth/register")
      .send({ name: "Test User", email: "test@najjar.om", password: "TestPass1" });
    expect(reg.status).toBe(201);
    expect(reg.body.token).toBeTruthy();

    const login = await request(app)
      .post("/api/auth/login")
      .send({ email: "test@najjar.om", password: "TestPass1" });
    expect(login.status).toBe(200);
    expect(login.body.user.email).toBe("test@najjar.om");

    const me = await request(app)
      .get("/api/auth/me")
      .set("Authorization", `Bearer ${login.body.token}`);
    expect(me.status).toBe(200);
    expect(me.body.user.name).toBe("Test User");
  });
});
