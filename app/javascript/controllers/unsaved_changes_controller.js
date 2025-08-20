import { Controller } from "@hotwired/stimulus";
import { TurboConfirm } from "@rolemodel/turbo-confirm";

/**
 * This adds a sparkle of javascript so the "Are you sure you want to leave this page?"
 * dialog isn't shown when there aren't any changes on the form yet
 */
export default class extends Controller {
  static targets = ["exitButton"];

  connect() {
    this.unsavedChanges = false;
  }

  onFormChange() {
    this.unsavedChanges = true;
  }

  onExitClick(event) {
    console.log(this.unsavedChanges);
    if (!this.unsavedChanges) {
      // No unsaved changes, proceed with the exit
      return;
    }
    // Ask for confirmation first
    event.preventDefault();
    const tc = new TurboConfirm();
    tc.confirmWithContent({
      "#confirm-title": "Are you sure?",
      "#confirm-body": "All unsaved changes will be discarded.",
    }).then((result) => {
      if (result) {
        // User confirmed, proceed with the exit
        window.location.href = event.target.href;
      }
    });
  }
}
