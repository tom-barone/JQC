import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cancelledCheckbox", "fieldsContainer"];

  connect() {
    this.updateCancelledState();
  }

  updateCancelledState() {
    if (this.cancelledCheckboxTarget.checked)
      this.fieldsContainerTarget.classList.add("application-cancelled");
    else this.fieldsContainerTarget.classList.remove("application-cancelled");
  }
}
