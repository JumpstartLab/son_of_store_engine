$(document).ready(function() {
  var old_slug = $("#store_slug").val();

  $(".edit_store").submit(function(e) {
    var new_slug = $("#store_slug").val();

    if(old_slug != new_slug) {
      var value = confirm("You are about to change the slug. This will break all the link. Continue?");
      if(value == true) {
        return true;
      }
    }
    else {
      return true;
    }

    $("#store_slug").val(old_slug);
    return false;
  });
});