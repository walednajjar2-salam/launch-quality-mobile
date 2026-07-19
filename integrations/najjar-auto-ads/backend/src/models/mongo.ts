import mongoose, { Schema } from "mongoose";

export interface IUserDoc {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  phone: string;
  role: string;
  rating: number;
  createdAt: string;
}

const userSchema = new Schema<IUserDoc>({
  id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  passwordHash: { type: String, required: true },
  phone: { type: String, default: "" },
  role: { type: String, default: "user" },
  rating: { type: Number, default: 5 },
  createdAt: { type: String, required: true },
});

export interface IAdDoc {
  id: string;
  title: string;
  description: string;
  make: string;
  carModel: string;
  year: number;
  price: number;
  mileage: number;
  fuel: string;
  transmission: string;
  color: string;
  city: string;
  images: string[];
  videoUrl: string;
  status: string;
  featured: boolean;
  ownerId: string;
  likes: string[];
  createdAt: string;
}

const adSchema = new Schema<IAdDoc>({
  id: { type: String, required: true, unique: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  make: { type: String, required: true },
  carModel: { type: String, required: true },
  year: { type: Number, required: true },
  price: { type: Number, required: true },
  mileage: { type: Number, required: true },
  fuel: { type: String, default: "بنزين" },
  transmission: { type: String, default: "أوتوماتيك" },
  color: { type: String, default: "" },
  city: { type: String, default: "مسقط" },
  images: { type: [String], default: [] },
  videoUrl: { type: String, default: "" },
  status: { type: String, default: "active" },
  featured: { type: Boolean, default: false },
  ownerId: { type: String, required: true },
  likes: { type: [String], default: [] },
  createdAt: { type: String, required: true },
});

adSchema.index({ status: 1, featured: -1, createdAt: -1 });
adSchema.index({ make: 1, carModel: 1, city: 1, price: 1 });

export const UserModel = mongoose.model<IUserDoc>("User", userSchema);
export const AdModel = mongoose.model<IAdDoc>("Ad", adSchema);

export async function connectMongo(uri: string): Promise<void> {
  mongoose.set("strictQuery", true);
  await mongoose.connect(uri);
}

export function toUserRow(doc: IUserDoc) {
  return {
    id: doc.id,
    name: doc.name,
    email: doc.email,
    password_hash: doc.passwordHash,
    phone: doc.phone,
    role: doc.role,
    rating: doc.rating,
    created_at: doc.createdAt,
  };
}

export function toAdRow(doc: IAdDoc) {
  return {
    id: doc.id,
    title: doc.title,
    description: doc.description,
    make: doc.make,
    car_model: doc.carModel,
    year: doc.year,
    price: doc.price,
    mileage: doc.mileage,
    fuel: doc.fuel,
    transmission: doc.transmission,
    color: doc.color,
    city: doc.city,
    images: JSON.stringify(doc.images || []),
    video_url: doc.videoUrl || "",
    status: doc.status,
    featured: doc.featured ? 1 : 0,
    owner_id: doc.ownerId,
    created_at: doc.createdAt,
  };
}
