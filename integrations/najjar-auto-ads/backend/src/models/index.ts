import mongoose, { Schema, Document, Types } from "mongoose";

export interface IUser extends Document {
  name: string;
  email: string;
  passwordHash: string;
  phone?: string;
  role: "user" | "dealer" | "admin";
  rating: number;
  createdAt: Date;
}

const userSchema = new Schema<IUser>(
  {
    name: { type: String, required: true, trim: true, maxlength: 120 },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    passwordHash: { type: String, required: true },
    phone: { type: String, trim: true },
    role: { type: String, enum: ["user", "dealer", "admin"], default: "user" },
    rating: { type: Number, default: 0, min: 0, max: 5 },
  },
  { timestamps: { createdAt: true, updatedAt: true } },
);

export const User = mongoose.model<IUser>("User", userSchema);

export interface IAd extends Document {
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
  videoUrl?: string;
  status: "active" | "sold" | "draft";
  featured: boolean;
  likes: Types.ObjectId[];
  owner: Types.ObjectId;
  createdAt: Date;
}

const adSchema = new Schema<IAd>(
  {
    title: { type: String, required: true, trim: true, maxlength: 200 },
    description: { type: String, required: true, maxlength: 5000 },
    make: { type: String, required: true, trim: true },
    carModel: { type: String, required: true, trim: true },
    year: { type: Number, required: true, min: 1970, max: 2030 },
    price: { type: Number, required: true, min: 0 },
    mileage: { type: Number, required: true, min: 0 },
    fuel: { type: String, default: "بنزين" },
    transmission: { type: String, default: "أوتوماتيك" },
    color: { type: String, default: "" },
    city: { type: String, default: "مسقط" },
    images: { type: [String], default: [] },
    videoUrl: { type: String },
    status: { type: String, enum: ["active", "sold", "draft"], default: "active" },
    featured: { type: Boolean, default: false },
    likes: [{ type: Schema.Types.ObjectId, ref: "User" }],
    owner: { type: Schema.Types.ObjectId, ref: "User", required: true },
  },
  { timestamps: { createdAt: true, updatedAt: true } },
);

adSchema.index({ make: 1, carModel: 1, year: -1, price: 1, city: 1, status: 1 });

export const Ad = mongoose.model<IAd>("Ad", adSchema);
