$ ->
  $("#store_update_submit").click (event)->
    if $('#store_domain').val() != $('#hidden_domain').html()
     event.preventDefault() if !confirm "You are about to change your store URL. This will break links. Would you like to proceed?"
