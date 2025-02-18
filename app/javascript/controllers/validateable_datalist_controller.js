import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  onChange() {
    console.log("onchange");
    const el = this.element;
    const datalist = el.list;

    // Determine whether an option exists with the current value of the input.
    let optionFound = false;
    for (let j = 0; j < datalist.options.length; j++) {
      if (el.value == datalist.options[j].value) {
        optionFound = true;
        break;
      }
    }
    // Use the setCustomValidity function of the Validation API
    // to provide an user feedback if the value does not exist in the datalist
    if (optionFound) {
      el.setCustomValidity("");
    } else {
      el.setCustomValidity("Please select a valid suburb.");
      el.reportValidity();
    }
  }
}
