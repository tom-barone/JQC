import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["riskRating", "uploadedTable"];

  connect() {
    console.log(this.uploadedTableTarget);
    this.setUploadedText();
  }

  onRiskRatingChange() {
    this.setUploadedText();
  }

  // When the risk rating changes, enable or disable the uploaded text fields appropriately
  setUploadedText() {
    const visible = this.riskRatingTarget.value == "";
    this.uploadedTableTarget.classList.toggle("risk-rating-set", !visible);
  }
}
