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
		// TODO: tidy this mess up
    const risk_rating = document.getElementById("application_risk_rating");
    if (!risk_rating) return;

    if (risk_rating.value !== "") {
      // Risk rating is set
      Array.from(
        this.element.getElementsByClassName("uploaded-text-enabled")
      ).forEach((el) => el.classList.remove("d-none"));
      Array.from(
        this.element.getElementsByClassName("uploaded-text-disabled")
      ).forEach((el) => el.classList.add("d-none"));
    } else {
      Array.from(
        this.element.getElementsByClassName("uploaded-text-enabled")
      ).forEach((el) => el.classList.add("d-none"));
      Array.from(
        this.element.getElementsByClassName("uploaded-text-disabled")
      ).forEach((el) => el.classList.remove("d-none"));
    }
  }
}
