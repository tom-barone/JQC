document.addEventListener("turbolinks:load", () => {

  // Show the errors modal when there is a problem saving
  $("#errorsModal").modal("show");

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
