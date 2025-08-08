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
  static targets = ["kdFee", "gst", "kdFeeTotal", "gstTotal"];

  connect() {
    this.updateGstAndTotals();
  }

  updateGstAndTotals() {
    // Update GST values
    this.kdFeeTargets.forEach((kdFee, index) => {
      const feeValue = _getFloat(kdFee);
      const gst = (feeValue / 10).toFixed(2);
      this.gstTargets[index].value = gst;
    });

    // Update totals
    const totals = [
      [this.kdFeeTotalTarget, this._visible(this.kdFeeTargets)],
      [this.gstTotalTarget, this._visible(this.gstTargets)],
    ];
    totals.forEach(([total, values]) => {
      total.innerHTML =
        "$ " +
        values
          .map((value) => _getFloat(value))
          .reduce((a, b) => a + b, 0)
          .toFixed(2);
    });
  }

  _visible(elements) {
    return elements.filter((element) => {
      const parentTrElement = element.closest("tr");
      return parentTrElement.style.display !== "none";
    });
  }
}
