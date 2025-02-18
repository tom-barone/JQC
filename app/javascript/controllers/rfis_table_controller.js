import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fields"];

  connect() {
    this.updateRfiNumbers();
  }

  updateRfiNumbers() {
    this.fieldsTargets
      .filter((row) => row.style.display !== "none")
      .forEach((row, index) => {
        row.querySelector(".rfis-number").innerHTML = index + 1;
      });
  }
}
