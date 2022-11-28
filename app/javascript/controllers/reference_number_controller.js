import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["referenceNumber", "convertedToFrom"];

  onApplicationTypeChange(event) {
    if (window.location.pathname.includes("/edit")) {
      // Currently editing an application
      if (
        !confirm(
          "You are about to convert an application.\n\n A copy of the old application will be kept."
        )
      ) {
        return false;
      }
      this._disableConvertToFromField();
      this._updateReferenceNumber(event);
    } else if (window.location.pathname.includes("/new")) {
      // New application
      this._updateReferenceNumber(event);
    }
  }

  _disableConvertToFromField() {
    this.convertedToFromTarget.disabled = true;
    this.convertedToFromTarget.value = "Auto generated";
  }

  _updateReferenceNumber(event) {
    const selected_application_type_id = parseInt(event.srcElement.value);

    if (isNaN(selected_application_type_id)) {
      console.error("Could not find the application type id");
      return;
    }

    const { application_type, last_used } = event.params.typeDetails.find(
      (x) => x.id === selected_application_type_id
    );
    this.referenceNumberTarget.value = `${application_type}${last_used + 1}`;
  }
}
