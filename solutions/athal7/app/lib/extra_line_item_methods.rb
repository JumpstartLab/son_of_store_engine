module ExtraLineItemMethods

  def create_order
    order = Order.create(store_id: @current_store.id)
    if session[:user_id]
      order.add_user(session[:user_id])
      order.try_to_add_billing_and_shipping(session[:user_id])
    end
    session[:order_id] = order.id
  end

  def lookup_line_item
    @line_item = LineItem.find(params[:id])
  end

  def lookup_order
    @line_item = LineItem.find(params[:id])
    @order = Order.find(@line_item.order_id)
  end
end
