import { Controller } from "@hotwired/stimulus";
import { TurboConfirm } from "@rolemodel/turbo-confirm";

export default class extends Controller {
  static targets = ["applicationType", "referenceNumber", "convertedToFrom"];

  connect() {
    // Save the initial value of the application type, in case we need to revert to it later
    this.lastApplicationType = this.applicationTypeTarget.value;
  }

  async onApplicationTypeChange(e) {
    // If changing to the blank option
    if (e.srcElement.value === "") return;

    const applicationType = e.srcElement.value;
    const typeDetails = e.params.typeDetails;

    // If we're editing an application
    if (window.location.pathname.includes("/edit")) {
      const tc = new TurboConfirm();
      // Confirm we really want to convert the application first
      const confirmed = await tc.confirmWithContent({
        "#confirm-title": "Convert Application?",
        "#confirm-body":
          "You are about to convert this application.<br/><br/> A copy will be made when you click <strong>Save</strong>.",
      });
      if (!confirmed) {
        // Reset the application type to the last value and finish.
        this.applicationTypeTarget.value = this.lastApplicationType;
        return;
      }

      this._disableConvertToFromField();
    }
    // Update the reference number
    this._updateReferenceNumber(applicationType, typeDetails);
    this.lastApplicationType = applicationType;
  }

  _disableConvertToFromField() {
    this.convertedToFromTarget.disabled = true;
    this.convertedToFromTarget.value = "Auto generated";
  }

  _updateReferenceNumber(applicationType, typeDetails) {
    const selected_application_type_id = Number.parseInt(applicationType);

    if (Number.isNaN(selected_application_type_id)) {
      console.error("Could not find the application type id");
      return;
    }

    const { application_type, last_used } = typeDetails.find(
      (x) => x.id === selected_application_type_id,
    );
    this.referenceNumberTarget.value = `${application_type}${last_used + 1}`;
  }
}
