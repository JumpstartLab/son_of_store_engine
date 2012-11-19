module ExtraShippingMethods

  def try_to_save_shipping
    if @shipping_address.save
      save_shipping
    else
      render :new
    end
  end

  def save_shipping
    notice = "Shipping Address Successfully Added"
    if logged_in?
      @shipping_address.update_attribute(:user_id, current_user.id)
    end
    if session[:order_id]
      order = Order.find(session[:order_id])
      order.update_attribute(:shipping_address_id, @shipping_address.id)
    end
    redirect_to session[:return_to]
  end

  def load_shipping_address
    if logged_in?
      @shipping_address = current_user.shipping_address
    else
      @shipping_address = ShippingAddress.find_by_order_id(session[:order_id])
    end
  end
end
