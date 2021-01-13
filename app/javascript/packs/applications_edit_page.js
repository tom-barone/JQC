document.addEventListener("turbolinks:load", () => {
  // Find all inputs on the DOM which are bound to a datalist via their list attribute.
  var inputs = document.querySelectorAll("input[list].list-option-required");
  for (var i = 0; i < inputs.length; i++) {
    // When the value of the input changes…
    inputs[i].addEventListener("change", function () {
      var optionFound = false,
        datalist = this.list;
      // Determine whether an option exists with the current value of the input.
      for (var j = 0; j < datalist.options.length; j++) {
        if (this.value == datalist.options[j].value) {
          optionFound = true;
          break;
        }
      }
      // use the setCustomValidity function of the Validation API
      // to provide an user feedback if the value does not exist in the datalist
      if (optionFound) {
        this.setCustomValidity("");
      } else {
        this.setCustomValidity("Please select a valid value.");
        this.reportValidity();
      }
    });
  }

  // Do the calculations for the invoice table totals
  const updateTotals = function () {
    var fields = ["fee", "insurance-levy", "gst", "dac", "lodgement"];

    var values_to_array = function (jquery_objects) {
      return jquery_objects
        .find("input")
        .map(function () {
          return Number.parseFloat($(this).val());
        })
        .toArray()
        .filter(function (val) {
          return !Number.isNaN(val);
        });
    };
    var sum = (acc, curr) => acc + curr;

    // calculate the GST of each row
    $(".invoice-gst-cell").each(function () {
      var insurance = values_to_array($(this).prev());
      var fee = values_to_array($(this).prev().prev());
      $(this)
        .find("input")
        .val((insurance.concat(fee).reduce(sum, 0) / 10).toFixed(2));
    });

    fields.forEach((field) => {
      var values = values_to_array($(`.invoice-${field}-cell`));
      $(`#${field}-total`).html("$ " + values.reduce(sum, 0).toFixed(2));
    });
  };

  // Whenever a field is edited - update the totals
  $(".invoice-table .nested-fields input").on("change", updateTotals);
  // When a new row is added or removed, make sure the handlers are attached again
  //
  $(".invoice-table").on("cocoon:after-insert", () => {
    $(".invoice-fields input").off("change", updateTotals);
    $(".invoice-fields input").on("change", updateTotals);
    updateTotals();
  });
  $(".invoice-table").on("cocoon:after-remove", () => {
    var x = $('.invoice-fields tr.nested-fields').filter(function () { 
        return this.style.display == 'none' 
    }).find('input.form-control').remove();
    updateTotals();
  });
  updateTotals();
});