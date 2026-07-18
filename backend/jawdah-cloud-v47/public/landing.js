(function () {
  "use strict";

  async function loadPreview() {
    try {
      const res = await fetch("/api/login_preview");
      const data = await res.json();
      const p = data.preview || {};
      const set = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.textContent = val;
      };
      set("lqStatProps", p.assets ?? "—");
      set("lqStatOcc", p.occupancy != null ? p.occupancy + "%" : "—");
      set("lqStatHealth", p.health != null ? p.health + "%" : "—");
    } catch (_) {
      /* preview optional */
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", loadPreview);
  } else {
    loadPreview();
  }
})();
