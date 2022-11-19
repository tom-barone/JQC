import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  setSpin(event) {
    this.element.innerHTML = `
        <span class='spinner-border spinner-border-sm' 
            role='status' 
            aria-hidden='true'></span>
        ${event.params.loadingText || ""}`;
  }

  // Use when the button needs to submit a form
  onSubmit(event) {
    this.setSpin(event);
    this.element.form.submit();
    this.element.disabled = true;
  }
}
