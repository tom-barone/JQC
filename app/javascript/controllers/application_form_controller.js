import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cancelledCheckbox", "fieldsContainer"];

  connect() {
    this.updateCancelledState();
    this.setApplicationUploadsState();
  }

  onFormChange() {
    this.updateCancelledState();
    this.setApplicationUploadsState();
  }

  updateCancelledState() {
    if (this.cancelledCheckboxTarget.checked)
      this.fieldsContainerTarget.classList.add("application-cancelled");
    else this.fieldsContainerTarget.classList.remove("application-cancelled");
  }

  setApplicationUploadsState() {
    const risk_rating = document.getElementById("application_risk_rating");
    const uploaded_table = document.getElementById("uploaded-table");

    if (risk_rating.value == "") {
      // If risk rating has no value, disallow entry on uploaded fields
      uploaded_table.classList.add("risk-rating-not-set");
    } else {
      // Allow entry on uploaded fields
      uploaded_table.classList.remove("risk-rating-not-set");
    }
  }
}
