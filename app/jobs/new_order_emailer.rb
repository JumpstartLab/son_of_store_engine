class NewOrderEmailer
  @queue = :emailer

  def self.perform(user_id, order_id)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    Notification.order_email(@user, @order).deliver
  end
end
