import { Controller } from "@hotwired/stimulus";

export function _getFloat(inputElement) {
  const value = Number.parseFloat(inputElement.value);
  if (Number.isNaN(value)) {
    inputElement.value = "";
    return 0;
  }
  inputElement.value = value;
  return value;
}

export default class extends Controller {
  static targets = ["fields", "footer"];

  connect() {
    this.updateGstAndTotals();
  }

  updateGstAndTotals() {
    const rows = this._getRows();

    // Update GST
    rows.forEach((row) => {
      const fee = _getFloat(row.fee);
      const gst = (fee / 10).toFixed(2);
      row.gst.value = gst;
    });

    // Update totals
    for (const [key, element] of Object.entries(this._getTotals())) {
      element.innerHTML =
        "$ " +
        rows
          .map((row) => _getFloat(row[key]))
          .reduce((a, b) => a + b, 0)
          .toFixed(2);
    }
  }

  _getTotals() {
    return {
      fee: this.footerTarget.querySelector("#fee-total"),
      gst: this.footerTarget.querySelector("#gst-total"),
      admin: this.footerTarget.querySelector("#admin-total"),
    };
  }

  _getRows() {
    const rows = Array.from(
      this.fieldsTarget.querySelectorAll(".invoice-table-row")
    ).filter((row) => row.style.display !== "none");

    return rows.map((row) => ({
      fee: row.querySelector(".invoice-fee-cell input"),
      gst: row.querySelector(".invoice-gst-cell input"),
      admin: row.querySelector(".invoice-admin-cell input"),
    }));
  }
}
