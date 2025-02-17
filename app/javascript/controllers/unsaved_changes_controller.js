import { Controller } from "@hotwired/stimulus";

/**
 * This adds a sparkle of javascript so the "Are you sure you want to leave this page?"
 * dialog isn't shown when there aren't any changes on the form yet
 */
export default class extends Controller {
  static targets = ["exitButton"];

  connect() {
    this.unsavedChanges = false;
    // Take off the confirm attributes from the exit button
    const attributes = ["data-turbo-confirm", "data-confirm-details"];
    this.confirmHtmlAttributes = {};
    for (const attribute of attributes) {
      this.confirmHtmlAttributes[attribute] =
        this.exitButtonTarget.getAttribute(attribute);
      this.exitButtonTarget.removeAttribute(attribute);
    }
  }

  onFormChange() {
    if (this.unsavedChanges) return;
    this.unsavedChanges = true;
    // Put back the confirm attributes on the exit button
    for (const [attribute, value] of Object.entries(
      this.confirmHtmlAttributes,
    )) {
      this.exitButtonTarget.setAttribute(attribute, value);
    }
  }
}
