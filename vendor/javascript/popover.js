// Initialise the Bootstrap Popovers
// https://popper.js.org/
// https://getbootstrap.com/docs/5.3/components/popovers

const popoverTriggerList = document.querySelectorAll(
  '[data-bs-toggle="popover"]'
);
[...popoverTriggerList].forEach(
  (popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl)
);
