module ExtraOrderMethods

  def cancel_order
    @order.update_attribute(:status, "cancelled")
    @order.set_action_time("cancelled")
    session[:order_id] = nil if @order.user == current_user
  end

  def transition_status
    session[:return_to] = request.url
    notice = "Transition successful"
    redirect_to session[:return_to], notice: notice
  end

  def store_orders
    Order.where(store_id: @current_store.id)
  end

  def user_store_orders
    Order.where(store_id: @current_store.id, user_id: current_user.id)
  end

  def confirm_has_store_admin_access
    redirect_to root_path unless current_user.is_admin_of(@current_store)
  end

  def lookup_order
    if params[:id]
      @order = store_orders.where(id: params[:id]).first
    end
  end

  def check_out
    notice = "Thank you for purchasing an email confirmation is on the way."
    @order.confirmation_email
    reset_session
    sid = @order.special_url
    redirect_to orders_lookup_path(@store, sid: sid), notice: notice
  end

  def reset_session
    session[:previous_order_id] = session[:order_id] if !logged_in?
    session[:order_id] = nil
  end

  def store_orders
    Order.where(store_id: @current_store.id)
  end

end
