document.addEventListener("turbolinks:load", () => {
  // Get important elements
  var select_type = document.getElementById("select_type");
  var start_date = document.getElementById("start_date");
  var end_date = document.getElementById("end_date");
  var search_text = document.getElementById("search_text");

  // If we're on the index page...
  if (start_date && end_date) {
    // Set the max for both datepickers to today
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var yyyy = today.getFullYear();
    if (dd < 10) {
      dd = "0" + dd;
    }
    if (mm < 10) {
      mm = "0" + mm;
    }
    today = yyyy + "-" + mm + "-" + dd;
    start_date.setAttribute("max", today);
    end_date.setAttribute("max", today);

    // Load in the search params if there
    var searchParams = new URLSearchParams(window.location.search);
    select_type.value = searchParams.get("type") || "";
    start_date.value = searchParams.get("start_date");
    end_date.value = searchParams.get("end_date");
    search_text.value = searchParams.get("search_text");

    window.clearSearchParams = function () {
      select_type.value = "";
      start_date.value = "";
      end_date.value = "";
      search_text.value = "";

      // clear the URL search params
      var newurl =
        window.location.protocol +
        "//" +
        window.location.host +
        window.location.pathname;
      window.history.replaceState({ path: newurl }, "", newurl);
    };

    window.search = function () {
      var searchParams = new URLSearchParams();

      var setParam = function (field, param) {
        if (field.value !== "") searchParams.set(param, field.value);
      };
      setParam(select_type, "type");
      setParam(start_date, "start_date");
      setParam(end_date, "end_date");
      setParam(search_text, "search_text");

      if (searchParams.toString() !== "") {
        Turbolinks.visit(
          window.location.pathname + "?" + searchParams.toString()
        );
      } else {
        Turbolinks.visit(window.location.pathname);
      }
    };
  }
});
