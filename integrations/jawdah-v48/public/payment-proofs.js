(function () {
  "use strict";

  /**
   * Launch Quality — إثباتات التحويل (v48)
   * 1) أضف في app.html قبل app.js:
   *    <script src="payment-proofs.js?v=pp1" defer></script>
   * 2) أضف قسم:
   *    <section id="sec-payment-proofs" class="section">...</section> (انظر LQ_PAYMENT_PROOFS.sectionHtml())
   * 3) في app.js — NAV_SAAS_ITEMS بعد invoices:
   *    ['payment-proofs','إثباتات التحويل','🧾']
   * 4) SECTION_TITLES: 'payment-proofs':'إثباتات التحويل'
   * 5) في showSection: if(resolved==='payment-proofs') LQ_PAYMENT_PROOFS.render();
   * يتطلب API: GET portal/proofs?status=  POST portal/review_proof
   */

  let _filter = "pending";
  let _counts = { pending: 0, approved: 0, rejected: 0 };

  function esc(s) {
    return typeof htmlEscape === "function" ? htmlEscape(s) : String(s || "");
  }

  function invoiceLabel(id) {
    const inv = ((window.Jawdah && Jawdah.data && Jawdah.data.invoices) || []).find((x) => x.id === id);
    return inv ? inv.invoice_no || inv.id : id || "—";
  }

  function clientNameForInvoice(invoiceId) {
    const inv = ((window.Jawdah && Jawdah.data && Jawdah.data.invoices) || []).find((x) => x.id === invoiceId);
    if (!inv) return "—";
    const c = ((window.Jawdah && Jawdah.data && Jawdah.data.clients) || []).find((x) => x.id === inv.client_id);
    return (c && c.name) || "—";
  }

  function statusBadge(status) {
    const s = String(status || "pending").toLowerCase();
    if (s === "approved") return '<span class="badge paid">موافق</span>';
    if (s === "rejected") return '<span class="badge overdue">مرفوض</span>';
    return '<span class="badge pending">معلّق</span>';
  }

  function canReview() {
    const r = window.Jawdah && Jawdah.user && Jawdah.user.role;
    return ["admin", "owner", "accountant", "operations"].includes(r);
  }

  async function loadCounts() {
    const statuses = ["pending", "approved", "rejected"];
    const out = { pending: 0, approved: 0, rejected: 0 };
    await Promise.all(
      statuses.map(async (st) => {
        try {
          const res = await api("portal/proofs?status=" + encodeURIComponent(st));
          out[st] = (res.items || []).length;
        } catch (_) {
          out[st] = 0;
        }
      })
    );
    _counts = out;
    return out;
  }

  async function fetchItems() {
    if (_filter === "all") {
      const parts = await Promise.all(
        ["pending", "approved", "rejected"].map((st) =>
          api("portal/proofs?status=" + encodeURIComponent(st)).then((r) => r.items || [])
        )
      );
      return parts.flat().sort((a, b) => String(b.submitted_at || "").localeCompare(String(a.submitted_at || "")));
    }
    const res = await api("portal/proofs?status=" + encodeURIComponent(_filter));
    return res.items || [];
  }

  function kpiHtml() {
    const m = typeof money === "function" ? money : (n) => n;
    return `<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:12px;margin-bottom:14px">
      <div class="saas-glass saas-fin-card"><span>معلّقة</span><strong>${_counts.pending}</strong></div>
      <div class="saas-glass saas-fin-card"><span>موافق</span><strong>${_counts.approved}</strong></div>
      <div class="saas-glass saas-fin-card"><span>مرفوض</span><strong>${_counts.rejected}</strong></div>
    </div>`;
  }

  function filtersHtml() {
    const opts = [
      ["pending", "معلّقة"],
      ["approved", "موافق عليها"],
      ["rejected", "مرفوضة"],
      ["all", "الكل"],
    ];
    return `<div class="toolbar">${opts
      .map(
        ([id, label]) =>
          `<button type="button" class="${_filter === id ? "gold-btn" : "ghost"}" onclick="LQ_PAYMENT_PROOFS.setFilter('${id}')">${label}</button>`
      )
      .join(" ")}</div>`;
  }

  function previewImage(src) {
    if (!src) {
      if (typeof toast === "function") toast("لا توجد صورة");
      return;
    }
    const w = window.open("", "_blank", "width=640,height=720");
    if (!w) return;
    w.document.write(`<html dir="rtl"><head><title>إثبات</title></head><body style="margin:0;background:#111"><img src="${esc(
      src
    )}" style="max-width:100%;height:auto;display:block;margin:auto"/></body></html>`);
  }

  async function review(proofId, action) {
    if (!proofId || !canReview()) return;
    const note = prompt(action === "approve" ? "ملاحظة الموافقة (اختياري)" : "سبب الرفض (اختياري)") || "";
    try {
      await api("portal/review_proof", {
        method: "POST",
        body: JSON.stringify({ proof_id: proofId, action, review_note: note }),
      });
      if (typeof toast === "function") toast(action === "approve" ? "تمت الموافقة" : "تم الرفض");
      if (typeof loadAll === "function") await loadAll();
      await render();
    } catch (e) {
      if (typeof toastErr === "function") toastErr(e);
    }
  }

  async function render() {
    const host = document.getElementById("paymentProofsBox");
    if (!host) return;
    host.innerHTML = '<p class="mini">جاري التحميل…</p>';
    try {
      await loadCounts();
      const items = await fetchItems();
      const rows = items.length
        ? items
            .map((p) => {
              const pending = String(p.status || "pending").toLowerCase() === "pending";
              const acts =
                pending && canReview()
                  ? `<button class="gold-btn" type="button" onclick="LQ_PAYMENT_PROOFS.review('${p.id}','approve')">موافقة</button> <button class="ghost" type="button" onclick="LQ_PAYMENT_PROOFS.review('${p.id}','reject')">رفض</button>`
                  : "—";
              const img = p.proof_image
                ? `<button type="button" class="ghost" onclick="LQ_PAYMENT_PROOFS.previewImage(${JSON.stringify(
                    String(p.proof_image)
                  )})">معاينة</button>`
                : "";
              return `<tr>
                <td><b>${esc(p.transfer_ref || p.id)}</b><br><small>${esc(p.note || "")}</small></td>
                <td>${esc(invoiceLabel(p.invoice_id))}<br><small>${esc(clientNameForInvoice(p.invoice_id))}</small></td>
                <td>${typeof money === "function" ? money(p.amount) : p.amount}</td>
                <td>${esc(p.submitted_at || "")}</td>
                <td>${statusBadge(p.status)}</td>
                <td>${img}</td>
                <td>${acts}</td>
              </tr>`;
            })
            .join("")
        : "<tr><td colspan='7'>لا توجد إثباتات في هذا التصنيف</td></tr>";
      host.innerHTML = `
        ${kpiHtml()}
        ${filtersHtml()}
        <div class="table-wrap"><table class="data-table">
          <thead><tr><th>المرجع</th><th>الفاتورة / العميل</th><th>المبلغ</th><th>التاريخ</th><th>الحالة</th><th>صورة</th><th>إجراء</th></tr></thead>
          <tbody>${rows}</tbody>
        </table></div>`;
      if (typeof ensureEnglishDigits === "function") ensureEnglishDigits(host);
    } catch (e) {
      host.innerHTML = `<p class="mini linked-bad">تعذر تحميل الإثباتات — تأكد من تفعيل API على الخادم.<br>${esc(
        e.message || e
      )}</p>`;
    }
  }

  function setFilter(id) {
    _filter = id || "pending";
    render();
  }

  function sectionHtml() {
    return `<section id="sec-payment-proofs" class="section">
      <div class="card"><h3>🧾 إثباتات التحويل البنكي</h3>
        <p class="mini">مراجعة إثباتات الدفع المرسلة من بوابة المستأجر — موافقة تسجّل التحصيل تلقائياً.</p>
        <div id="paymentProofsBox"></div>
        <div class="toolbar" style="margin-top:12px"><button type="button" class="ghost" onclick="LQ_PAYMENT_PROOFS.render()">تحديث</button></div>
      </div>
    </section>`;
  }

  window.LQ_PAYMENT_PROOFS = {
    render,
    review,
    setFilter,
    previewImage,
    sectionHtml,
  };
})();
