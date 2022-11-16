import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  setSpinner(event) {
    this.element.innerHTML = `<span class='spinner-border spinner-border-sm' role='status' aria-hidden='true'></span> ${
      event.params.loadingText || ""
    }`;
    this.element.form.submit();
    this.element.disabled = true;
  }
}