# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
  old_url = $("#store_url").val()
  $(".edit_store").submit ->
    new_url = $("#store_url").val()
    if (old_url != new_url)
      value = confirm "Are you sure you wish to update the URL? This will break all existing links."
      if (value == true)
        return true
      else
        $("#store_url").val(old_url)
        return false
    else
      return true

  return false