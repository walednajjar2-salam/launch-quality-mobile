/* Launch Quality · Oman hospitality map (Leaflet) */
(function () {
  const CITY = {
    muscat: [23.5880, 58.3829],
    مسقط: [23.5880, 58.3829],
    nizwa: [22.9333, 57.5333],
    نزوى: [22.9333, 57.5333],
    barka: [23.7070, 57.8890],
    بركاء: [23.7070, 57.8890],
    seeb: [23.6703, 58.1891],
    السيب: [23.6703, 58.1891],
  };

  let map = null;
  let layer = null;

  function parseCoords(p) {
    const notes = String(p?.notes || "");
    const m = notes.match(/lat\s*=\s*(-?\d+(?:\.\d+)?)\s*,\s*lng\s*=\s*(-?\d+(?:\.\d+)?)/i);
    if (m) return [Number(m[1]), Number(m[2])];
    const loc = String(p?.location || "").toLowerCase();
    for (const [key, coords] of Object.entries(CITY)) {
      if (loc.includes(key.toLowerCase()) || String(p?.location || "").includes(key)) return coords;
    }
    return [23.5880, 58.3829];
  }

  function statusColor(status) {
    const s = String(status || "");
    if (s.includes("صيان") || /maint/i.test(s)) return "#ef4444";
    if (s.includes("شاغ") || /vacant/i.test(s)) return "#3b82f6";
    if (s.includes("محج") || /pend|reserv/i.test(s)) return "#f59e0b";
    return "#d4af37";
  }

  function ensureMap() {
    const host = document.querySelector(".saas-map-panel .gis-pro");
    if (!host || typeof L === "undefined") return null;
    if (map) return map;

    host.classList.add("lq-leaflet-host");
    let mapEl = document.getElementById("lqOmanMap");
    if (!mapEl) {
      mapEl = document.createElement("div");
      mapEl.id = "lqOmanMap";
      mapEl.className = "lq-oman-map";
      host.insertBefore(mapEl, host.firstChild);
    }

    map = L.map(mapEl, {
      zoomControl: true,
      attributionControl: true,
      scrollWheelZoom: false,
    }).setView([23.2, 57.9], 7);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution: "&copy; OpenStreetMap",
    }).addTo(map);

    layer = L.layerGroup().addTo(map);
    setTimeout(() => map.invalidateSize(), 200);
    return map;
  }

  function popupHtml(p) {
    const photo =
      typeof lqPropertyImageUrl === "function" ? lqPropertyImageUrl(p) : null;
    const label =
      typeof propertyLabel === "function" ? propertyLabel(p) : p.name || p.id;
    const moneyFn = typeof money === "function" ? money : (n) => `${n} ر.ع`;
    const thumb = photo
      ? `<img class="lq-map-hotel-photo" src="${photo}" alt="${label}">`
      : `<div class="lq-map-hotel-fallback">🏨</div>`;
    return `
      <div class="lq-map-popup">
        ${thumb}
        <strong>${label}</strong>
        <span>${p.location || "Oman"}</span>
        <b>${moneyFn(p.price || 0)} / شهر</b>
        <em>${p.status || ""}</em>
      </div>`;
  }

  function renderHospitalityMap(props) {
    const m = ensureMap();
    if (!m || !layer) return false;
    layer.clearLayers();
    const bounds = [];
    (props || []).forEach((p) => {
      const [lat, lng] = parseCoords(p);
      bounds.push([lat, lng]);
      const marker = L.circleMarker([lat, lng], {
        radius: 10,
        color: "#fff",
        weight: 2,
        fillColor: statusColor(p.status),
        fillOpacity: 0.95,
      });
      marker.bindPopup(popupHtml(p), { maxWidth: 280 });
      marker.addTo(layer);
    });
    if (bounds.length) {
      try {
        m.fitBounds(bounds, { padding: [28, 28], maxZoom: 11 });
      } catch (_) {
        m.setView(bounds[0], 10);
      }
    }
    setTimeout(() => m.invalidateSize(), 120);
    return true;
  }

  window.lqRenderHospitalityMap = renderHospitalityMap;
  window.addEventListener("resize", () => {
    if (map) setTimeout(() => map.invalidateSize(), 100);
  });
})();
