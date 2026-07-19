import request from "supertest";
import { createApp } from "../app.js";
import { User } from "../models/index.js";
import { hashPassword } from "../utils/auth.js";

describe("ads routes", () => {
  const app = createApp();
  let token = "";

  beforeEach(async () => {
    const user = await User.create({
      name: "Seller",
      email: "seller@najjar.om",
      passwordHash: await hashPassword("SellerPass1"),
      role: "dealer",
    });
    const login = await request(app)
      .post("/api/auth/login")
      .send({ email: "seller@najjar.om", password: "SellerPass1" });
    token = login.body.token;
    expect(token).toBeTruthy();
    void user;
  });

  it("creates, lists, updates and likes ads", async () => {
    const created = await request(app)
      .post("/api/ads")
      .set("Authorization", `Bearer ${token}`)
      .send({
        title: "Test Car",
        description: "Great car",
        make: "Toyota",
        model: "Corolla",
        year: 2021,
        price: 4500,
        mileage: 50000,
        city: "مسقط",
      });
    expect(created.status).toBe(201);
    const id = created.body.item.id;

    const list = await request(app).get("/api/ads");
    expect(list.status).toBe(200);
    expect(list.body.items.length).toBeGreaterThan(0);

    const one = await request(app).get(`/api/ads/${id}`);
    expect(one.status).toBe(200);

    const updated = await request(app)
      .put(`/api/ads/${id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({ price: 4300 });
    expect(updated.status).toBe(200);
    expect(updated.body.item.price).toBe(4300);

    const liked = await request(app)
      .post(`/api/ads/${id}/like`)
      .set("Authorization", `Bearer ${token}`);
    expect(liked.status).toBe(200);
    expect(liked.body.item.liked).toBe(true);
  });
});
