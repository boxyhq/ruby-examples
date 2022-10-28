// Thanks to https://www.w3schools.com/howto/howto_js_snackbar.asp
window.showToast = function () {
  // Get the toast DIV
  var x = document.getElementsByClassName("toast")[0];

  // Add the "show" class to DIV
  x.className += " show";

  // After 3 seconds, remove the show class from DIV
  setTimeout(function () {
    x.className = x.className.replace("show", "");
  }, 3000);
};
