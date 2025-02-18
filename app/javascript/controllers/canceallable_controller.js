import { Controller } from "@hotwired/stimulus";

/**
 * This adds a sparkle of javascript so when the cancelled field is set
 * it will disable and grey out the entire form
 */
export default class extends Controller {
  static targets = ["cancelledCheckbox", "fieldsContainer"];

  connect() {
    this.setCancelledState();
  }

  setCancelledState() {
    var disableFields = this.cancelledCheckboxTarget.checked;
    this.fieldsContainerTargets.forEach((container) => {
      if (disableFields) {
        container.style.opacity = 0.6;
        container.style.pointerEvents = "none";
      } else {
        container.style.opacity = 1;
        container.style.pointerEvents = "auto";
      }
    });
  }
}
