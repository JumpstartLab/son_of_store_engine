  $(function() {
    $("#draggable").draggable();
    $("#droppable").droppable({
      drop: function( event, ui ) {
        $( this )
          $('#add-to-cart-button').click()
      }
    });
  });