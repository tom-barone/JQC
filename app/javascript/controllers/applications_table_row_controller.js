import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["editButton"];

  navigate(event) {
    this.editButtonTarget.click();
    Turbo.visit(event.params.editPath);
  }
}