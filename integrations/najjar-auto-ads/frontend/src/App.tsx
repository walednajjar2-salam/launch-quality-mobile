import { FormEvent, useCallback, useEffect, useMemo, useState } from "react";
import { Ad, User, api } from "./api";

type Tab = "home" | "ads" | "profile";

const TOKEN_KEY = "najjar_ads_token";

function money(n: number) {
  return n.toLocaleString("en-US") + " ر.ع";
}

export default function App() {
  const [tab, setTab] = useState<Tab>("home");
  const [token, setToken] = useState(localStorage.getItem(TOKEN_KEY) || "");
  const [user, setUser] = useState<User | null>(null);
  const [ads, setAds] = useState<Ad[]>([]);
  const [myAds, setMyAds] = useState<Ad[]>([]);
  const [search, setSearch] = useState("");
  const [city, setCity] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [authMode, setAuthMode] = useState<"login" | "register" | null>(null);
  const [authForm, setAuthForm] = useState({ name: "", email: "", password: "", phone: "" });
  const [newAd, setNewAd] = useState({
    title: "",
    description: "",
    make: "",
    model: "",
    year: 2022,
    price: 5000,
    mileage: 40000,
    city: "مسقط",
  });

  const loadAds = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const params = new URLSearchParams();
      if (search.trim()) params.set("q", search.trim());
      if (city.trim()) params.set("city", city.trim());
      const res = await api.ads(params.toString() ? params.toString() : "", token || undefined);
      setAds(res.items);
    } catch (e) {
      setError(e instanceof Error ? e.message : "فشل تحميل الإعلانات");
    } finally {
      setLoading(false);
    }
  }, [search, city, token]);

  const loadProfile = useCallback(async () => {
    if (!token) {
      setUser(null);
      setMyAds([]);
      return;
    }
    try {
      const me = await api.me(token);
      setUser(me.user);
      const mine = await api.myAds(token);
      setMyAds(mine.items);
    } catch {
      localStorage.removeItem(TOKEN_KEY);
      setToken("");
      setUser(null);
    }
  }, [token]);

  useEffect(() => {
    loadAds();
  }, [loadAds]);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const featured = useMemo(() => ads.filter((a) => a.featured).slice(0, 3), [ads]);

  async function handleAuth(e: FormEvent) {
    e.preventDefault();
    setError("");
    try {
      const res =
        authMode === "register"
          ? await api.register(authForm)
          : await api.login({ email: authForm.email, password: authForm.password });
      localStorage.setItem(TOKEN_KEY, res.token);
      setToken(res.token);
      setUser(res.user);
      setAuthMode(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : "فشل الدخول");
    }
  }

  async function handleCreateAd(e: FormEvent) {
    e.preventDefault();
    if (!token) return setAuthMode("login");
    setError("");
    try {
      await api.createAd(newAd, token);
      setNewAd({ title: "", description: "", make: "", model: "", year: 2022, price: 5000, mileage: 40000, city: "مسقط" });
      await loadAds();
      await loadProfile();
      setTab("profile");
    } catch (err) {
      setError(err instanceof Error ? err.message : "فشل إنشاء الإعلان");
    }
  }

  async function toggleLike(ad: Ad) {
    if (!token) return setAuthMode("login");
    try {
      const res = await api.like(ad.id, token);
      setAds((prev) => prev.map((a) => (a.id === ad.id ? res.item : a)));
    } catch (err) {
      setError(err instanceof Error ? err.message : "فشل التفضيل");
    }
  }

  function logout() {
    localStorage.removeItem(TOKEN_KEY);
    setToken("");
    setUser(null);
    setMyAds([]);
  }

  return (
    <div className="app">
      <header className="header">
        <div className="brand">
          <span className="logo">🚗</span>
          <div>
            <h1>NAJJAR Auto Ads</h1>
            <p>منصة إعلانات السيارات — عُمان</p>
          </div>
        </div>
        <nav>
          <button className={tab === "home" ? "active" : ""} onClick={() => setTab("home")}>الرئيسية</button>
          <button className={tab === "ads" ? "active" : ""} onClick={() => setTab("ads")}>الإعلانات</button>
          <button className={tab === "profile" ? "active" : ""} onClick={() => setTab("profile")}>حسابي</button>
        </nav>
        <div className="auth-actions">
          {user ? (
            <>
              <span className="user-pill">{user.name}</span>
              <button className="ghost" onClick={logout}>خروج</button>
            </>
          ) : (
            <>
              <button className="ghost" onClick={() => setAuthMode("login")}>دخول</button>
              <button className="gold" onClick={() => setAuthMode("register")}>تسجيل</button>
            </>
          )}
        </div>
      </header>

      {error && <div className="alert">{error}</div>}

      <main>
        {tab === "home" && (
          <section className="hero">
            <div>
              <h2>بيع وشراء السيارات باحتراف</h2>
              <p>منصة NAJJAR لإعلانات السيارات — عربي بالكامل، تصميم حديث، بحث وفلترة متقدمة.</p>
              <div className="hero-actions">
                <button className="gold" onClick={() => setTab("ads")}>تصفح الإعلانات</button>
                <button className="ghost" onClick={() => (token ? setTab("profile") : setAuthMode("register"))}>
                  {token ? "إعلاناتي" : "ابدأ مجاناً"}
                </button>
              </div>
            </div>
            <div className="hero-stats">
              <div><strong>{ads.length}</strong><span>إعلان نشط</span></div>
              <div><strong>{featured.length}</strong><span>مميز</span></div>
              <div><strong>24/7</strong><span>متاح</span></div>
            </div>
          </section>
        )}

        {(tab === "ads" || tab === "home") && (
          <section className="panel">
            <div className="toolbar">
              <input placeholder="بحث: تويota، كامري..." value={search} onChange={(e) => setSearch(e.target.value)} />
              <input placeholder="المدينة" value={city} onChange={(e) => setCity(e.target.value)} />
              <button className="gold" onClick={loadAds} disabled={loading}>{loading ? "..." : "بحث"}</button>
            </div>
            <div className="grid">
              {ads.map((ad) => (
                <article key={ad.id} className={`card ${ad.featured ? "featured" : ""}`}>
                  <div className="car-thumb">{ad.make[0]}{ad.model[0]}</div>
                  <div className="card-body">
                    <h3>{ad.title}</h3>
                    <p className="meta">{ad.make} {ad.model} · {ad.year} · {ad.city}</p>
                    <p className="price">{money(ad.price)}</p>
                    <p className="desc">{ad.description.slice(0, 120)}...</p>
                    <div className="card-actions">
                      <button className="ghost" onClick={() => toggleLike(ad)}>
                        {ad.liked ? "❤️" : "🤍"} {ad.likesCount}
                      </button>
                      <span className="badge">{ad.mileage.toLocaleString()} km</span>
                    </div>
                  </div>
                </article>
              ))}
              {!loading && ads.length === 0 && <p className="empty">لا توجد إعلانات مطابقة</p>}
            </div>
          </section>
        )}

        {tab === "profile" && (
          <section className="panel profile">
            {!user ? (
              <div className="empty-box">
                <p>سجّل الدخول لإدارة إعلاناتك</p>
                <button className="gold" onClick={() => setAuthMode("login")}>تسجيل الدخول</button>
              </div>
            ) : (
              <>
                <div className="profile-card">
                  <h2>{user.name}</h2>
                  <p>{user.email}</p>
                  <p>{user.phone || "—"} · {user.role}</p>
                </div>
                <form className="create-form" onSubmit={handleCreateAd}>
                  <h3>إنشاء إعلان جديد</h3>
                  <div className="form-grid">
                    <input placeholder="عنوان الإعلان" value={newAd.title} onChange={(e) => setNewAd({ ...newAd, title: e.target.value })} required />
                    <input placeholder="الماركة" value={newAd.make} onChange={(e) => setNewAd({ ...newAd, make: e.target.value })} required />
                    <input placeholder="الموديل" value={newAd.model} onChange={(e) => setNewAd({ ...newAd, model: e.target.value })} required />
                    <input type="number" placeholder="السعر" value={newAd.price} onChange={(e) => setNewAd({ ...newAd, price: Number(e.target.value) })} required />
                    <input type="number" placeholder="السنة" value={newAd.year} onChange={(e) => setNewAd({ ...newAd, year: Number(e.target.value) })} required />
                    <input type="number" placeholder="الممشى" value={newAd.mileage} onChange={(e) => setNewAd({ ...newAd, mileage: Number(e.target.value) })} required />
                    <input placeholder="المدينة" value={newAd.city} onChange={(e) => setNewAd({ ...newAd, city: e.target.value })} />
                  </div>
                  <textarea placeholder="الوصف" value={newAd.description} onChange={(e) => setNewAd({ ...newAd, description: e.target.value })} required />
                  <button className="gold" type="submit">نشر الإعلان</button>
                </form>
                <h3>إعلاناتي ({myAds.length})</h3>
                <div className="grid small">
                  {myAds.map((ad) => (
                    <article key={ad.id} className="card">
                      <div className="card-body">
                        <h4>{ad.title}</h4>
                        <p className="price">{money(ad.price)}</p>
                        <span className="badge">{ad.status}</span>
                      </div>
                    </article>
                  ))}
                </div>
              </>
            )}
          </section>
        )}
      </main>

      <footer>
        <p>NAJJAR Auto Ads Platform v1.0.0 · Launch Quality LLC · info@alamal.info</p>
      </footer>

      {authMode && (
        <div className="modal-backdrop" onClick={() => setAuthMode(null)}>
          <form className="modal" onSubmit={handleAuth} onClick={(e) => e.stopPropagation()}>
            <h2>{authMode === "login" ? "تسجيل الدخول" : "حساب جديد"}</h2>
            {authMode === "register" && (
              <>
                <input placeholder="الاسم" value={authForm.name} onChange={(e) => setAuthForm({ ...authForm, name: e.target.value })} required />
                <input placeholder="الجوال" value={authForm.phone} onChange={(e) => setAuthForm({ ...authForm, phone: e.target.value })} />
              </>
            )}
            <input type="email" placeholder="البريد" value={authForm.email} onChange={(e) => setAuthForm({ ...authForm, email: e.target.value })} required />
            <input type="password" placeholder="كلمة المرور" value={authForm.password} onChange={(e) => setAuthForm({ ...authForm, password: e.target.value })} required />
            <button className="gold" type="submit">{authMode === "login" ? "دخول" : "تسجيل"}</button>
            <button type="button" className="ghost full" onClick={() => setAuthMode(null)}>إلغاء</button>
            {authMode === "login" && (
              <p className="hint">تجريبي: admin@najjar.om / Najjar2026!</p>
            )}
          </form>
        </div>
      )}
    </div>
  );
}
