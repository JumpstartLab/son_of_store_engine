module ShippingDetailsHelper

  def formatted_shipping_address(shipping_detail)
    "#{ shipping_detail.ship_to_name }<br />
    #{ shipping_detail.ship_to_address_1 }<br />
    #{ shipping_detail.ship_to_address_2 }<br />
    #{ shipping_detail.ship_to_city },
    #{ shipping_detail.ship_to_state }
    #{ shipping_detail.ship_to_zip }"
  end

end
