// Get important elements
var select_type = document.getElementById("select_type");
var start_date = document.getElementById("start_date");
var end_date = document.getElementById("end_date");
var search_text = document.getElementById("search_text");

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
    Turbolinks.visit(window.location.pathname + "?" + searchParams.toString());
  } else {
    Turbolinks.visit(window.location.pathname);
  }
};

//var searchValue = widget.parent.children.SearchBox.value;
//var searchString = searchValue ? searchValue : '';
//var type = widget.parent.children.TypeDropdown.value;
//var regex = /[^\s-"']+|-?"[^"]*"|-?'[^']*'|-?[^\s"']+/g;
//var data = widget.datasource;

//var fields = ['ReferenceNo',
//'DANo',
//'StreetNo',
//'LotNo',
//'StreetName',
//'Description',
//'ClientID_rel.ClientName',
//'OwnerID_rel.ClientName',
//'ApplicantID_rel.ClientName',
//'SuburbID_rel.DisplayName',
//'CouncilID_rel.Name',
//];

//var array = searchString.match(regex);
//data.query.where = '';
//if (array) {
//var whereStr = '';
//for (var i=0; i<array.length; i++) {
//// Check for negative sign
//var exclude = false;
//if (array[i].charAt(0) === '-') {
//array[i] = array[i].replace(/[-]+/g, '');
//exclude = true;
//}

//// Remove quotes
//array[i] = array[i].replace(/['"]+/g, '');

//var paramStr = 'param' + i;
//if (i !== 0) {
//whereStr += 'and ';
//}
//if (exclude) {
//whereStr += '( ';
//for (var k=0; k<fields.length; k++){
//if (k !== 0) {
//whereStr += 'and ';
//}
//whereStr += fields[k] + ' notContains? :' + paramStr + ' ';
//}
//whereStr += ') ';
//} else {
//whereStr += '( ';
//for (var k=0; k<fields.length; k++){
//if (k !== 0) {
//whereStr += 'or ';
//}
//whereStr += fields[k] + ' contains :' + paramStr + ' ';
//}
//whereStr += ') ';
//}
////data.query.where = whereStr;
////data.query.parameters[paramStr] = term;
//}

//var field = 'ApplicationID';
//var args = 10;

//for (var i=array.length; i<=args; i++) {
//if (i !== 0) {
//whereStr += 'and ';
//}
//whereStr += field + ' != :param' + i + ' ';
//}

//whereStr = whereStr.trim();
//data.query.where = "("+whereStr+")";
//for (var j=0; j<array.length; j++) {
//var p = 'param' + j;
//data.query.parameters[p] = array[j];
//}
//}

//data.query.filters.ApplicationType_rel.ApplicationType._equals = type;
//// Date range
//if (widget.parent.children.DateFrom.value) {
//data.query.filters.DateEntered._greaterThanOrEquals = widget.parent.children.DateFrom.value;
//} else {
//data.query.filters.DateEntered._greaterThanOrEquals = new Date(1900,1);
//}
//if (widget.parent.children.DateTo.value) {
//data.query.filters.DateEntered._lessThanOrEquals = widget.parent.children.DateTo.value;
//} else {
//// Only show applications up to today by default
//data.query.filters.DateEntered._lessThanOrEquals = new Date();
//}
////data.query.sorting.DateEntered._descending();
//data.query.sorting.SortPriorityGen._ascending();
//data.query.sorting.ReferenceNo._descending();
//data.load();
