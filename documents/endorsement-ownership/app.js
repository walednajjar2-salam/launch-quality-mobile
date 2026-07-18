(function () {
  const d = window.ENDORSEMENT_DATA;
  if (!d) {
    document.getElementById("page").innerHTML =
      "<p style='padding:24px'>تعذّر تحميل data.js</p>";
    return;
  }

  const e = (s) =>
    String(s ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");

  const field = (key, value, multiline = false) => {
    const cls = multiline ? ' class="name-cell"' : "";
    const html = multiline
      ? e(value).replace(/\r?\n/g, "<br>")
      : e(value);
    return `<span contenteditable="false" data-key="${e(key)}"${cls}>${html}</span>`;
  };

  function render() {
    const participantDisplay = d.participantName || "";

    document.getElementById("page").innerHTML = `
      <header class="header">
        <img class="logo" src="assets/gig-oman-logo.png?v=2" alt="GIG Gulf Insurance Oman" />
        <div class="company">
          <div class="company-ar" contenteditable="false" data-key="company.nameAr">${e(
            d.company.nameAr
          )}</div>
          <div class="company-en" contenteditable="false" data-key="company.nameEn">${e(
            d.company.nameEn
          )}</div>
          <div class="company-addr">
            <span contenteditable="false" data-key="company.addressEn">${e(
              d.company.addressEn
            )}</span>
            <span class="ar" contenteditable="false" data-key="company.addressAr">${e(
              d.company.addressAr
            )}</span>
          </div>
        </div>
      </header>

      <div class="doc-title">
        <div class="ar" contenteditable="false" data-key="title.ar">${e(
          d.title.ar
        )}</div>
        <div class="en" contenteditable="false" data-key="title.en">${e(
          d.title.en
        )}</div>
        <div class="cover-type">
          <span contenteditable="false" data-key="coverTypeEn">${e(
            d.coverTypeEn
          )}</span>
          <span class="sep">|</span>
          <span contenteditable="false" data-key="coverTypeAr">${e(
            d.coverTypeAr
          )}</span>
        </div>
      </div>

      <table class="details">
        <thead>
          <tr>
            <th colspan="3">
              Endorsement Details
              <span class="ar">تفاصيل ملحق الوثيقة</span>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr class="zebra">
            <td class="lbl">Cover Type</td>
            <td class="val">${field("coverTypeEn", d.coverTypeEn)} / ${field(
              "coverTypeAr",
              d.coverTypeAr
            )}</td>
            <td class="arlbl">نوع التغطية</td>
          </tr>
          <tr>
            <td class="lbl">Policy Number</td>
            <td class="val">${field("policyNumber", d.policyNumber)}</td>
            <td class="arlbl">رقم الوثيقة</td>
          </tr>
          <tr class="zebra">
            <td class="lbl">Period of Insurance</td>
            <td class="val">${field("periodOfInsurance", d.periodOfInsurance)}</td>
            <td class="arlbl">فترة التأمين</td>
          </tr>
          <tr>
            <td class="lbl">Endorsement Number</td>
            <td class="val">${field("endorsementNumber", d.endorsementNumber)}</td>
            <td class="arlbl">رقم الملحق</td>
          </tr>
          <tr class="zebra">
            <td class="lbl">Endorsement Sequence</td>
            <td class="val">${field("endorsementSequence", d.endorsementSequence)}</td>
            <td class="arlbl">رقم تسلسلي للملحق</td>
          </tr>
          <tr>
            <td class="lbl">Endorsement Period</td>
            <td class="val">${field("endorsementPeriod", d.endorsementPeriod)}</td>
            <td class="arlbl">الفترة التأمينية للملحق</td>
          </tr>
          <tr class="zebra">
            <td class="lbl">Issue Date &amp; Time</td>
            <td class="val">${field("issueDateTime", d.issueDateTime)}</td>
            <td class="arlbl">تاريخ اصدار الوثيقة والوقت</td>
          </tr>
        </tbody>
      </table>

      <table class="split">
        <tbody>
          <tr class="zebra">
            <td class="l-lbl">Name of the participant</td>
            <td class="l-val">${field(
              "participantName",
              participantDisplay,
              true
            )}</td>
            <td class="l-ar">اسم المشترك</td>
            <td class="r-lbl mid-line">Vehicle Est Value<br/>R.O.</td>
            <td class="r-val">${field("vehicleEstValue", d.vehicleEstValue)}</td>
            <td class="r-ar">قيمة المركبة</td>
          </tr>
          <tr>
            <td class="l-lbl">Mortgage if any</td>
            <td class="l-val">${field("mortgage", d.mortgage)}</td>
            <td class="l-ar">الرهن ان وجد</td>
            <td class="r-lbl mid-line">Make</td>
            <td class="r-val">${field("make", d.make)}</td>
            <td class="r-ar">اسم المركبة</td>
          </tr>
          <tr class="zebra">
            <td class="l-lbl">Address</td>
            <td class="l-val">${field("address", d.address)}</td>
            <td class="l-ar">العنوان</td>
            <td class="r-lbl mid-line">Model</td>
            <td class="r-val">${field("model", d.model)}</td>
            <td class="r-ar">نوع المركبة</td>
          </tr>
          <tr>
            <td class="l-lbl">Contact Number</td>
            <td class="l-val">${field("contactNumber", d.contactNumber)}</td>
            <td class="l-ar">رقم الهاتف</td>
            <td class="r-lbl mid-line">Body Type</td>
            <td class="r-val">${field("bodyType", d.bodyType)}</td>
            <td class="r-ar">نوع الهيكل</td>
          </tr>
          <tr class="zebra">
            <td class="l-lbl">Customer VAT Reg<br/>Number:</td>
            <td class="l-val">${field("customerVatReg", d.customerVatReg)}</td>
            <td class="l-ar">رقم سجل ضريبة<br/>القيمة المضافة للعميل</td>
            <td class="r-lbl mid-line">Year of Manufacture</td>
            <td class="r-val">${field("yearOfManufacture", d.yearOfManufacture)}</td>
            <td class="r-ar">سنة الصنع</td>
          </tr>
          <tr>
            <td class="l-lbl">A/C Code :</td>
            <td class="l-val">${field("acCode", d.acCode)}</td>
            <td class="l-ar">رمز العميل</td>
            <td class="r-lbl mid-line">Seating Capacity</td>
            <td class="r-val">${field("seatingCapacity", d.seatingCapacity)}</td>
            <td class="r-ar">سعة المقاعد الاجمالي</td>
          </tr>
          <tr class="zebra">
            <td class="l-lbl">A/C Name :</td>
            <td class="l-val">${field("acName", d.acName)}</td>
            <td class="l-ar">اسم العميل</td>
            <td class="r-lbl mid-line">CC/HP</td>
            <td class="r-val">${field("ccHp", d.ccHp)}</td>
            <td class="r-ar">سعة المحرك / الاحصنة</td>
          </tr>
          <tr>
            <td class="l-lbl">Registration Number</td>
            <td class="l-val">${field("registrationNumber", d.registrationNumber)}</td>
            <td class="l-ar">رقم اللوحة</td>
            <td class="r-lbl mid-line">Weight</td>
            <td class="r-val">${field("weight", d.weight)}</td>
            <td class="r-ar">وزن المركبة</td>
          </tr>
          <tr class="zebra charges-row">
            <td class="l-lbl">Engine Number</td>
            <td class="l-val">${field("engineNumber", d.engineNumber)}</td>
            <td class="l-ar">رقم المحرك</td>
            <td class="r-lbl mid-line">Endorsement<br/>Charges</td>
            <td class="r-val">${field("endorsementCharges", d.endorsementCharges)}</td>
            <td class="r-ar">رسوم الملحق</td>
          </tr>
          <tr>
            <td class="l-lbl">Chassis Number</td>
            <td class="l-val">${field("chassisNumber", d.chassisNumber)}</td>
            <td class="l-ar">رقم القاعدة (الشاصي)</td>
            <td class="r-lbl mid-line">VAT @ 5%</td>
            <td class="r-val">${field("vat", d.vat)}</td>
            <td class="r-ar">ضريبة القيمة المضافة</td>
          </tr>
          <tr class="zebra">
            <td class="l-lbl">Usage Type</td>
            <td class="l-val">${field("usageType", d.usageType)}</td>
            <td class="l-ar">الغرض من الترخيص</td>
            <td class="r-lbl mid-line">Total</td>
            <td class="r-val">${field("total", d.total)}</td>
            <td class="r-ar">مجموع الاجمالي للاشتراك</td>
          </tr>
        </tbody>
      </table>

      <div class="green-bar"></div>

      <section class="declaration">
        <p contenteditable="false" data-key="declarationIntro">${e(
          d.declarationIntro
        )}</p>
        <p contenteditable="false" data-key="declarationTransfer">${e(
          d.declarationTransfer
        )}</p>
        <p contenteditable="false" data-key="declarationFooter">${e(
          d.declarationFooter
        )}</p>
      </section>

      <div class="witness-line">
        <div class="left" contenteditable="false" data-key="signedAtText">${e(
          d.signedAtText
        )}</div>
        <div class="right" contenteditable="false" data-key="signedOnBehalf">${e(
          d.signedOnBehalf
        )}</div>
      </div>

      <div class="sign-area">
        <div class="meta-left">
          Endorsement Initiator: <span contenteditable="false" data-key="initiator">${e(
            d.initiator
          )}</span><br/>
          Endorsement Initiation Branch: <span contenteditable="false" data-key="initiationBranch">${e(
            d.initiationBranch
          )}</span><br/>
          Approved By: <span contenteditable="false" data-key="approvedBy">${e(
            d.approvedBy
          )}</span>
        </div>
        <div class="sign-right">
          <div class="ar-sign">توقيع المصرح</div>
          <div class="co" contenteditable="false" data-key="company.nameEn">${e(
            d.company.nameEn
          )}</div>
          <div class="signature-line"></div>
          <div class="auth" contenteditable="false" data-key="authorizedSignatory">${e(
            d.authorizedSignatory
          )}</div>
          ${
            d.company.taxCardNo
              ? `<div class="tax">Tax Card No: <span contenteditable="false" data-key="company.taxCardNo">${e(
                  d.company.taxCardNo
                )}</span></div>`
              : ""
          }
        </div>
      </div>
    `;
  }

  function setEditable(on) {
    document.body.classList.toggle("editing", on);
    document.querySelectorAll("[data-key]").forEach((el) => {
      el.setAttribute("contenteditable", on ? "true" : "false");
    });
    const btn = document.getElementById("toggleEdit");
    btn.textContent = on ? "إيقاف التعديل" : "تفعيل التعديل";
  }

  function setByPath(obj, path, value) {
    const parts = path.split(".");
    let cur = obj;
    for (let i = 0; i < parts.length - 1; i++) {
      if (cur[parts[i]] == null || typeof cur[parts[i]] !== "object") {
        cur[parts[i]] = {};
      }
      cur = cur[parts[i]];
    }
    cur[parts[parts.length - 1]] = value;
  }

  function syncFromDom() {
    document.querySelectorAll("[data-key]").forEach((el) => {
      setByPath(d, el.getAttribute("data-key"), el.innerText.trim());
    });
  }

  function downloadJson() {
    syncFromDom();
    const blob = new Blob(
      [
        "window.ENDORSEMENT_DATA = " +
          JSON.stringify(d, null, 2) +
          ";\n",
      ],
      { type: "application/javascript;charset=utf-8" }
    );
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "data.js";
    a.click();
    URL.revokeObjectURL(a.href);
  }

  let editing = false;
  document.getElementById("toggleEdit").addEventListener("click", () => {
    if (editing) syncFromDom();
    editing = !editing;
    setEditable(editing);
  });
  document.getElementById("exportJson").addEventListener("click", downloadJson);
  document.getElementById("printBtn").addEventListener("click", () => {
    if (editing) syncFromDom();
    window.print();
  });

  render();
})();
