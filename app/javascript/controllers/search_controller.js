import { Controller } from "@hotwired/stimulus";

export function _getFormattedDateString(date) {
  var dd = date.getDate();
  var mm = date.getMonth() + 1; //January is 0!
  var yyyy = date.getFullYear();
  if (dd < 10) {
    dd = "0" + dd;
  }
  if (mm < 10) {
    mm = "0" + mm;
  }
  return yyyy + "-" + mm + "-" + dd;
}

export default class extends Controller {
  static targets = ["type", "startDate", "endDate", "searchText"];

  connect() {
    const today = _getFormattedDateString(new Date());
    this.startDateTarget.setAttribute("max", today);
    this.endDateTarget.setAttribute("max", today);
  }

  resetForm() {
    this.typeTarget.value = "";
    this.startDateTarget.value = "";
    this.endDateTarget.value = "";
    this.searchTextTarget.value = "";
  }
}
