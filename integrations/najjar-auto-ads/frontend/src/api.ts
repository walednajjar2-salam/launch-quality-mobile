export const API_BASE =
  import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, "") || "/api";

export interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: string;
  rating: number;
}

export interface Ad {
  id: string;
  title: string;
  description: string;
  make: string;
  model: string;
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
  likesCount: number;
  liked: boolean;
  ownerId: string;
  createdAt: string;
}

async function request<T>(path: string, opts: RequestInit = {}, token?: string): Promise<T> {
  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    ...(opts.headers as Record<string, string>),
  };
  if (token) headers.Authorization = `Bearer ${token}`;
  const res = await fetch(`${API_BASE}${path}`, { ...opts, headers });
  const data = await res.json();
  if (!res.ok || data.ok === false) {
    throw new Error(data.error || "Request failed");
  }
  return data as T;
}

export const api = {
  health: () => request<{ ok: boolean }>("/health"),
  register: (body: { name: string; email: string; password: string; phone?: string }) =>
    request<{ token: string; user: User }>("/auth/register", { method: "POST", body: JSON.stringify(body) }),
  login: (body: { email: string; password: string }) =>
    request<{ token: string; user: User }>("/auth/login", { method: "POST", body: JSON.stringify(body) }),
  me: (token: string) => request<{ user: User }>("/auth/me", {}, token),
  ads: (query = "", token?: string) =>
    request<{ items: Ad[]; total: number }>(`/ads${query ? `?${query}` : ""}`, {}, token),
  myAds: (token: string) => request<{ items: Ad[] }>("/ads/mine", {}, token),
  like: (id: string, token: string) =>
    request<{ item: Ad }>(`/ads/${id}/like`, { method: "POST" }, token),
  createAd: (body: Record<string, unknown>, token: string) =>
    request<{ item: Ad }>("/ads", { method: "POST", body: JSON.stringify(body) }, token),
};
