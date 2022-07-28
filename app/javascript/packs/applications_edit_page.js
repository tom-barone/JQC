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
    var fields = ["fee", "insurance-levy", "gst", "admin", "dac", "lodgement"];

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
    var x = $(".invoice-fields tr.nested-fields")
      .filter(function () {
        return this.style.display == "none";
      })
      .find("input.form-control")
      .remove();
    updateTotals();
  });
  updateTotals();

  // Show the errors modal when there is a problem saving
  $("#errorsModal").modal("show");

  // When they change an applicant / council input, don't let them click it until saved
  $(".editable-association").change(function () {
    //$(this).next('a').addClass("disabled")
    $(this).next("a").remove();
  });

  const updateCancelledView = function (isCancelled) {
    if (isCancelled) {
      $("#application_form_container").addClass("application-cancelled");
    } else {
      $("#application_form_container").removeClass("application-cancelled");
    }
  };
  $("#application_cancelled").change(function () {
    updateCancelledView(this.checked);
  });
  updateCancelledView($("#application_cancelled").is(":checked"));

  // When changing the application type...
  let previousValue = "";
  window.onTypeFocus = function () {
    previousValue = this.value;
  };
  window.onTypeChange = function (types) {
    if (window.location.pathname.includes("/edit")) {
      if (
        confirm(
          "You are about to convert an application.\n\n A copy of the old application will be kept."
        ) === false
      ) {
        this.value = previousValue;
        return false;
      }
      $("#application_converted_to_from")
        .prop("disabled", true)
        .val("Auto generated");
    } else {
      onTypeChangeNew.call(this);
    }

    // Put the new reference number in
    if (this.value) {
      const { application_type, last_used } = types[this.value - 1];
      $("#application_reference_number").val(
        `${application_type}${last_used + 1}`
      );
    }
  };
  const onTypeChangeNew = function () {};

  const checkRiskRatingAndUpdateUploaded = function () {
    const risk_rating_is_set = $("#application_risk_rating").val() !== "";
    if (risk_rating_is_set) {
      // Allow entry
      $(".uploaded-text-enabled").removeClass("d-none");
      $(".uploaded-text-disabled").removeClass("d-none").addClass("d-none");
    } else {
      // Disable entry
      $(".uploaded-text-enabled").removeClass("d-none").addClass("d-none");
      $(".uploaded-text-disabled").removeClass("d-none");
    }
  };
  // Initial set
  checkRiskRatingAndUpdateUploaded();
  // On risk rating change
  $("#application_risk_rating").change(checkRiskRatingAndUpdateUploaded);
  $("#application-add-uploaded").click(() =>
    setTimeout(checkRiskRatingAndUpdateUploaded, 100)
  );

  // Update the numbers on RFI_issued list
  // Hide the add button when there's 5 RFIs
  const updateRFIs = function () {
    const rfiRows = $(".request-for-informations-fields td.rfis-number:visible")

    // In the RFI table, add a numbered list to the left
    rfiRows.each(function (
      index
    ) {
      $(this).html(index + 1);
    });

    if (rfiRows.length >= 5) {
      $("#rfis-button-add").hide()
    } else {
      $("#rfis-button-add").show()
    }
  };
  // Make sure to update the numbers on add/remove RFI
  $(".rfis-table").on("cocoon:after-insert", updateRFIs);
  $(".rfis-table").on("cocoon:after-remove", updateRFIs);
  // Update the RFIs on edit page load
  updateRFIs();
});
